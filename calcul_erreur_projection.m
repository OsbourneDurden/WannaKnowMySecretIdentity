function [ erreur_projection ] = calcul_erreur_projection( points_image , points_image_projete )
%% Calcul de l'erreur de projection (en pixels)
%
% INPUT : [points_image, points_image_projete] matrices N points dans le 
% plan image ordonnés de la même manière
% OUTPUT : [erreur_projection] scalaire définissant l'erreur de projection
% en pixels
%
% On calcule la distance entre les deux matrices, point par point.

%% Initialisation des variables
Mp = points_image_projete;
mi = points_image;
erreur_projection = 0;

%% Résolution du système
for i=1:length(points_image)
	erreur_projection = erreur_projection + norm(Mp(:,i) - mi(:,i)); 
end

end