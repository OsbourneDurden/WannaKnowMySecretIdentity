clear all;
close all;

%cam = webcam(1);
%cam.Resolution = cam.AvailableResolutions{end};
figure;

g=0;

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
    subplot(1,4,1);
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
    subplot(1,4,2);
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
    subplot(1,4,3);
    imshow(img);
    if (isempty(mire) == 0)
        hold on;
        plot(mire(:,1),mire(:,2),'b+');
    end
    
    
    
    %% regroupement des points mire proches
    % recherche de la plus grande distance séparant deux points mire
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
    
    % recherche des points mire proches entre eux par rapport à max
    [Nm, ~] = size(mire);
    mireBis = [];
    for i=1:Nm
        alias = [];

        for j=1:Nm
            dist = distance( mire(i,2), mire(i,1), mire(j,2), mire(j,1) );

            if (dist < (max/15)) & (dist > 0)
                if isempty( find( alias == j ) ) 

                    alias = [alias ; j];

                end
            end
        end
        
        % Pour un groupe de points mire proches, établir un point médian
        if isempty(alias) == 0
            posMoy = mean([mire(i,:) ; mire(alias,:)]);
            if isempty(mireBis)
                mireBis = [mireBis ; posMoy];             
            elseif isempty( find( mireBis(:,1) == posMoy(1) ) ) &  isempty( find( mireBis(:,2) == posMoy(2) ) )                   
                mireBis = [mireBis ; posMoy];             
            end
        else
        % Si point mire isolé, ne rien faire 
            mireBis = [mireBis ; mire(i,:)];             
        end
    end
    
    
    % afficher mire sans dédoublement
    subplot(1,4,4);
    imshow(img);
    if (isempty(mireBis) == 0)
        hold on;
        plot(mireBis(:,1),mireBis(:,2),'b+');
    end
    
    
    

end
