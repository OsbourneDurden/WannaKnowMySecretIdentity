function imgCorner = cornerDetector(imgSrc)

    [~, Ix, Iy] = edgeDetector (imgSrc);
%% Matrice de Harris M   
%    M = [   Ix²     ,   Ix*Iy ;
%            Iy*Ix   ,   Ix²     ];

%% Calcul de son déterminant
     Det = ( (Ix.^2) .* (Iy.^2) - (Ix .* Iy).^2 );
     
%% Calcul de sa trace
     Trace = (Ix.^2) + (Iy.^2);
     
%% Réponse du detecteur de Harris
    R = (Det - 0.04* (Trace.^2));

    maxR = max(max(R,[],2)');   % valeur max de la réponse (plus forts coins)
    %imgCorner = (R > (mean2(R)*80)); % Seuillage avec 40% du plus fort coin
    R = R/mean2(R);
    R(R < (mean2(R)/2)) = 0;

    
%% Maximums locaux
    [Height, Width] = size(R);
    R = R(8:Height-7,8:Width-7);  % Annuler l'effet "zero-pad" aux bords
    [Height, Width] = size(R);  
    imgCorner = zeros(Height, Width);
    
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
    [I(:,2),I(:,1)] = find(imgCorner == 1);
    imgCorner = I;
    
    %coin = sum(imgCorner(:)==1)
end
