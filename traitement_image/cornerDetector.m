function imgCorner = cornerDetector(imgSrc)
% Donne un matrice de coordonnés de points à partir d'une image NdG.
% utilise la détection de contours "edgeDetector.m"

    [edges, ~, Ix, Iy] = edgeDetector (imgSrc);
  
    subplot(2,4,2);
    imshow(edges);
    hold on;
    title('Module du gradient (passe haut gaussien)');
    pause(0.001);
    
%% Matrice de Harris M   
%    M = [   Ix?     ,   Ix*Iy ;
%            Iy*Ix   ,   Ix?     ];

%% Calcul de son d?terminant
     Det = ( (Ix.^2) .* (Iy.^2) - (Ix .* Iy).^2 );
     
%% Calcul de sa trace
     Trace = (Ix.^2) + (Iy.^2);
     
%% R?ponse du detecteur de Harris
    R = (Det - 0.04* (Trace.^2));
    
    % Seuillage
    R = R/mean2(R);
    R(R < (mean2(R)/2)) = 0;

    
%% Maximums locaux
    [Height, Width] = size(R);
    R = R(8:Height-7,8:Width-7);  % Annuler l'effet "zero-pad" aux bords
    [Height, Width] = size(R);  
    imgCorner = zeros(Height, Width);
    
    % Trouve les max locaux dans une matrice carré de 9x9, autour de tous les coins trouvés
    for i = round(Height*0.05):9:round(Height*0.95)
        for j = round(Width*0.05):9:round(Width*0.95)
            localMax = max(max(R(i-4:i+4,j-4:j+4)));
             if localMax ~= 0 
                 for m = i-4:i+4
                    for n = j-4:j+4
                        if R(m,n) == localMax
                            imgCorner(m,n) = 1;
                        end
                    end
                 end
             end
        end
    end
    
    % Trouve les coordonnées des coins et les range dans imgCorner
    [I(:,2),I(:,1)] = find(imgCorner == 1);
    imgCorner = I;
    
end
