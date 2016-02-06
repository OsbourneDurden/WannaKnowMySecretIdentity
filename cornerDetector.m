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
    R = abs(Det - 0.0* (Trace.^2));

    maxR = max(max(R,[],2)');   % valeur max de la réponse (plus forts coins)
    imgCorner = (R > (mean2(R)*80)); % Seuillage avec 40% du plus fort coin
    sum(imgCorner(:) == 1)

end
