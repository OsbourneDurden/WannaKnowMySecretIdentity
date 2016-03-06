function mireCornersBis = mireDetector(img)
% Prend une image RGB en argument et retourne la position des sommets de 
% la mire rouge, si celle-ci est pr�sente. Si tel est le cas, les sommets
% seront ordonn�s en commencant par le plus �loign� du centre, puis en
% tournant dans le sens horaire.

    pause(0.001);
    
    [Height, Width, ~] = size(img);
    
    
    %% detection coins    
    corners = cornerDetector(mean(img,3));
    
    
    % afficher coins
    subplot(2,4,3);
    cla();
    imshow(img);
    hold on;
    plot(corners(:,1),corners(:,2),'b+');
    title('Coins par la m�thode de Harris');
    
    
    
    %% detection zones rouges
    % Isolation des zones o? le rouge est 20% plus fort que le vert et que le bleu
    imgRedOnly = ( (img(:,:,1)>(1.2*img(:,:,2)) & (img(:,:,1)>(1.2*img(:,:,3)) )));
    
    
    % On �rode 4 fois pour supprimer le bruit 
    mask = [0,1,0 ; 1,1,1 ; 0,1,0];
    imgRedOnly = conv2(double(imgRedOnly),double(mask),'same')>4;
    imgRedOnly = conv2(double(imgRedOnly),double(mask),'same')>4;
    imgRedOnly = conv2(double(imgRedOnly),double(mask),'same')>4;
    imgRedOnly = conv2(double(imgRedOnly),double(mask),'same')>4;
    imgRedOnly = conv2(double(imgRedOnly),double(mask),'same')>4;
    
    
    % Dilatation avec un masque unitaire de 15 pixel de large pour �tre sur
    % que les pixels rouge aux coins de la mire soient d�tect�s
    imgRedOnly = conv2(double(imgRedOnly),double(ones(15)),'same');
    
    
    % afficher zones rouges et les coins
    subplot(2,4,4);
    cla();
    imshow(imgRedOnly);
    hold on;
    plot(corners(:,1),corners(:,2),'b+');
    title('Superposition avec les zones � dominance rouge');

    
    
    %% croisement zones rouges + coins = points mire
    mire = [];
    % un coin n'est stoqu� dans mire que si il est sur un pixel d�tect�
    % comme rouge
    if (isempty(corners) == 0)
        [Nc, ~] = size(corners);
        for i=1:Nc
            if imgRedOnly( corners(i,2), corners(i,1) )
                mire = [mire; corners(i,:)];
            end
        end
    end
    
    
    % afficher mire
    subplot(2,4,5);
    cla();
    imshow(img);
    if (isempty(mire) == 0)
        hold on;
        plot(mire(:,1),mire(:,2),'b+');
    end
    title('Points potentiels de la mire rouge');
    
    
    
    %% recherche de la plus grande distance s?parant deux points mire (pour avoir une id�e de sa taille dans l'image)
    if (isempty(mire) == 0)
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
    end

    
    
    %% regroupement des coins proches (relativement � la taille de la mire)
    mireBis = [];
    if (isempty(mire) == 0)
        mireBis = regroupPoints(mire,(max/50));
        mireTmp = [];
        i=0;

        while mean2(mireTmp) ~= mean2(mireBis) % ici mean2 sert de 'checksum' pour trouver le moment o? l'on ne peut plus regrouper de points
            mireTmp = regroupPoints(mireBis,(max/50));
            mireBis = regroupPoints(mireTmp,(max/50)); 
            i = i+1;
            if i>10
                break;
            end
        end 
    end
    
    
    % afficher mire sans d?doublement
    subplot(2,4,6);
    cla();
    imshow(img);
    if (isempty(mireBis) == 0)
        hold on;
        plot(mireBis(:,1),mireBis(:,2),'b+');
    end
    title('Points d�terminant la mire rouge');

    
    
    %% calcul du centre de la mire
    centre = [];
    if (isempty(mire) == 0)
        centre = [mean2(mire(:,1)), mean2(mire(:,2))];
    end
    
    
    %% recherche des coins de la mire potentiels (eg les points les plus loin du centre)
    mireCorners = [];
    if (isempty(mireBis) == 0)
        [Nm, ~] = size(mireBis);
        mireCorners = zeros(10,2);
        
        % En recherchant 30 sommets potentiels on est quasi certain de
        % trouver les 4 vrais parmis eux
        for i=1:30
            max=0;
            for j=1:Nm
                % Distance entre le centre et un point (actuel)
                dist = distance( centre(2), centre(1), mireBis(j,2), mireBis(j,1) );
                
                if dist > max 
                    if (i>1) 
                        % arriv� ici on a le point actuel le plus �loingn�
                        % du centre
                        prevDist = distance( centre(2), centre(1), mireCorners(i-1,2), mireCorners(i-1,1) );
                        
                        if dist < prevDist
                            % ici on s'assure que le point actuel le plus �loingn�
                            % est plus petit que le point le plus �loign�
                            % pr�c�dant (ainsi on �limine les doublons)
                            max = dist;
                            mireCorners(i,:) = mireBis(j,:);
                        end  
                    end

                    if i == 1
                        % cas sp�cial du premier point actuel
                        max = dist;
                        mireCorners(i,:) = mireBis(j,:);
                    end
                end
            end
        end
    end
    
    
    %% selections des meilleurs coins de la mire (eg les points trouv?s par rotation du coin le plus loin du centre)
    if (isempty(mireCorners) == 0)
        
        % calcul des 3 rotations successives, autour du centre, � 90�, 
        % du sommet certain (le plus loin)
        mireCornersRot = zeros(4,2);
        mireCornersRot(1,:) = mireCorners(1,:);
        
        P = distance( centre(2), centre(1), mireCornersRot(1,2), mireCornersRot(1,1) );
        Teta = asin( -(mireCornersRot(1,1)-centre(1)) / P );

        for i=2:4
            Teta = Teta+pi/2; %teta + 90�
            mireCornersRot(i,:) = [centre(1) - sin(Teta)*P, centre(2) + cos(Teta)*P];
        end


        % calcul des points les plus proche des points tourn?s
        [Nm, ~] = size(mireCorners);
        mireCornersBis = zeros(4,2);
        mireCornersBis(1,:) = mireCorners(1,:);

        for i=2:4
            % On prend une distance minimale de d�part entre la rotation et 
            % le coins volontairement plus grande que l'image 
            min = Height+Width;
            
            for j=1:Nm
                % distance entre chaque sommet potentiel (j) et sa position
                % id�ale (i) (selon la rotation du sommet certain)
                dist = distance( mireCornersRot(i,2), mireCornersRot(i,1), mireCorners(j,2), mireCorners(j,1) );
                if dist < min 
                    % arriv� ici on est sur d'avoir le point le plus proche
                    % de celui tourn�
                    min = dist;
                    mireCornersBis(i,:) = mireCorners(j,:);
                end
            end
        end
    end
    
    
    % afficher le centre et les coins de la mire
    subplot(2,4,7);
    cla();
    imshow(img);
    
    if (isempty(centre) == 0)
        hold on;
        plot(centre(:,1),centre(:,2),'gd');
    end
    
    if (isempty(mireCorners) == 0)
        hold on;
        plot(mireCornersBis(1,1),mireCornersBis(1,2),'b+');
        plot(mireCornersBis(2,1),mireCornersBis(2,2),'b+');
        plot(mireCornersBis(3,1),mireCornersBis(3,2),'b+');
        plot(mireCornersBis(4,1),mireCornersBis(4,2),'b+');
        text(mireCornersBis(1,1)+10,mireCornersBis(1,2),'1');
        text(mireCornersBis(2,1)+10,mireCornersBis(2,2),'2');
        text(mireCornersBis(3,1)+10,mireCornersBis(3,2),'3');
        text(mireCornersBis(4,1)+10,mireCornersBis(4,2),'4');
    end
    title('Sommets de la mire rouge et son centre (vert)');

    
end