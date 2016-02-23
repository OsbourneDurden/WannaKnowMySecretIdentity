clear all;
close all;

%cam = webcam(1);
%cam.Resolution = cam.AvailableResolutions{end};
figure;

g = 20;

while true
    %% Acquisition
    %img = snapshot(cam);

    g=g+1;
    img =  imread(['rec/', num2str(g,'%05d'), '.png']);
    pause(0.02);
    
    [Height, Width, ~] = size(img);
    
    
    
    %% detection coins    
    %corners = cornerDetector(img);
    corners = corner(mean(img,3));
    
    
    % afficher coins
    subplot(2,4,1);
    cla();
    imshow(img);
    hold on;
    plot(corners(:,1),corners(:,2),'b+');
    
    
    
    %% detection zones rouges
    
    % Isolation des zones où le rouge est plus fort que le vert et le bleu
    imgRedOnly = ( (img(:,:,1)>(1.2*img(:,:,2)) & (img(:,:,1)>(1.2*img(:,:,3)) )));
    
    % Erosion
    mask = [0,1,0 ; 1,1,1 ; 0,1,0];
    imgRedOnly = conv2(double(imgRedOnly),double(mask),'same')>4;
    imgRedOnly = conv2(double(imgRedOnly),double(mask),'same')>4;
    imgRedOnly = conv2(double(imgRedOnly),double(mask),'same')>4;
    imgRedOnly = conv2(double(imgRedOnly),double(mask),'same')>4;
    imgRedOnly = conv2(double(imgRedOnly),double(mask),'same')>4;
    
    % Dilatation
    imgRedOnly = conv2(double(imgRedOnly),double(ones(15)),'same');
    
    
    % afficher zones rouges et les coins
    subplot(2,4,2);
    cla();
    imshow(imgRedOnly);
    hold on;
    plot(corners(:,1),corners(:,2),'b+');
    
    
    
    %% croisement zones rouges + coins = points mire
    mire = [];
    [Nc, ~] = size(corners);
    for i=1:Nc
        if imgRedOnly( corners(i,2), corners(i,1) )
            mire = [mire; corners(i,:)];
        end
    end
    
    
    % afficher mire
    subplot(2,4,3);
    cla();
    imshow(img);
    if (isempty(mire) == 0)
        hold on;
        plot(mire(:,1),mire(:,2),'b+');
    end
    
    
    
    %% recherche de la plus grande distance séparant deux points mire
    max=0;
    [Nm, ~] = size(mire);
    for i=1:Nm
        for j=1:Nm
            dist = distance( mire(i,2), mire(i,1), mire(j,2), mire(j,1) );
            if dist > max 
                max = dist;
            end
        end
    end

    
    
    %% regroupement des coins proches    
    mireBis = regroupPoints(mire,(max/20));
    mireTmp = [];
    i=0;
    
    while mean2(mireTmp) ~= mean2(mireBis) % ici mean2 sert de 'checksum' pour trouver le moment où l'on ne peut plus regrouper de points
        mireTmp = regroupPoints(mireBis,(max/20));
        mireBis = regroupPoints(mireTmp,(max/20)); 
        i = i+1;
        if i>10
            break;
        end
    end 
   
    % afficher mire sans dédoublement
    subplot(2,4,4);
    cla();
    imshow(img);
    if (isempty(mireBis) == 0)
        hold on;
        plot(mireBis(:,1),mireBis(:,2),'b+');
    end
    
    
    %% calcul du centre de la mire
    centre = [mean2(mireBis(:,1)), mean2(mireBis(:,2))];
    
    
    
    %% recherche des coins de la mire potentiels (eg les points les plus loin du centre)
    [Nm, ~] = size(mireBis);
    mireCorners = zeros(10,2);
    
    for i=1:10
        max=0;
        for j=1:Nm
            dist = distance( centre(2), centre(1), mireBis(j,2), mireBis(j,1) );
            if dist > max 
                
                if (i>1) 
                    prevDist = distance( centre(2), centre(1), mireCorners(i-1,2), mireCorners(i-1,1) );
                    if dist < prevDist
                        max = dist;
                        mireCorners(i,:) = mireBis(j,:);
                    end  
                end
                
                if i == 1
                    max = dist;
                    mireCorners(i,:) = mireBis(j,:);
                end
            end
        end
    end
    
    
    
    %% selections des meilleurs coins de la mire (eg les points trouvés par rotation du coin certains, le plus loin du centre)
    % calcul des points tournés
    mireCornersRot = zeros(4,2);
    mireCornersRot(1,:) = mireCorners(1,:);
    P = distance( centre(2), centre(1), mireCornersRot(1,2), mireCornersRot(1,1) );
    Teta = asin( -(mireCornersRot(1,1)-centre(1)) / P );
    
    for i=2:4
        Teta = Teta+pi/2;
        mireCornersRot(i,:) = [centre(1) - sin(Teta)*P, centre(2) + cos(Teta)*P];
    end
    
    
    % calcul des points les plus proche des points tournés
    [Nm, ~] = size(mireCorners);
    mireCornersBis = zeros(4,2);
    mireCornersBis(1,:) = mireCorners(1,:);
    
    for i=2:4
        min = Height+Width;
        for j=1:Nm
            dist = distance( mireCornersRot(i,2), mireCornersRot(i,1), mireCorners(j,2), mireCorners(j,1) );
            if dist < min 
                min = dist;
                mireCornersBis(i,:) = mireCorners(j,:);
            end
        end
    end
    
    
    
    % afficher le centre et les coins de la mire
    subplot(2,4,5);
    cla();
    imshow(img);
    if (isempty(centre) == 0)
        hold on;
        plot(centre(:,1),centre(:,2),'gd');
    end
    if (isempty(mireCorners) == 0)
        hold on;
        plot(mireCornersBis(1,1),mireCornersBis(1,2),'b+');
        plot(mireCornersBis(2,1),mireCornersBis(2,2),'b*');
        plot(mireCornersBis(3,1),mireCornersBis(3,2),'bd');
        plot(mireCornersBis(4,1),mireCornersBis(4,2),'bo');
    end
    

    
    

end
