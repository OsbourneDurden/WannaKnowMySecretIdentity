function [ points_image ] = minimisation_erreur_projection( points_monde, points_image )
%% Minimisation de l'erreur de projection d'un problème
%
% INPUT : [points_monde, points_image] où points_monde est une matrice
% N*3 de points dans le monde, et points_image est une matrice de N*2 
% points dans le plan image
% OUTPUT : points_image, une matrice de N*2 points dans le plan image
%
% On cherche à minimiser la différence entre les points_image et les
% points images projetés par la matrice de projection de ces points. On
% minimise donc la différence d'un certain pas et on le fait tant qu'on
% arrive à minimiser l'erreur de projection de cette manière.

%% Initialisation des variables
pi = points_image;
step = 0.01;
err = 1000;
[ matrice_projection ] = calcul_matrice_projection_dlt( points_monde , pi );
[ pip ] = projection_points( points_monde , matrice_projection );
[ new_err ] = calcul_erreur_projection( pi , pip );
disp(['Erreur de projection avant minimisation : ', num2str(new_err), ' pixels']);

%% Minimisation
while err >= new_err
    
    [ matrice_projection ] = calcul_matrice_projection_dlt( points_monde , pi );
    [ pip ] = projection_points( points_monde , matrice_projection );
    err=new_err;
    [ new_err ] = calcul_erreur_projection( pi , pip );
    
    if err >= new_err
        %% Recherche du pixel le plus éloigné 
        diff = abs(mean(pip-pi));
        indice_pixel = find( max(diff) == diff);
        
        difference_pixel = pip(:,indice_pixel)-pi(:,indice_pixel);
        eloignement_pixel = abs(difference_pixel);
        
        %% Recherche de la coordonée à réduire d'un certain pas
        coordonnee = find(max(eloignement_pixel) == eloignement_pixel);
        pi(coordonnee, indice_pixel) = pi(coordonnee, indice_pixel) + ...
            sign(difference_pixel(coordonnee))*step;
        
    else
        % Sinon on ne peut plus réduire, on arrête la boucle
        break;
    end
    
    
end
disp(['Erreur de projection après minimisation : ', num2str(new_err), ' pixels']);
points_image=pi;
end