%% Initialisation du workspace
clear variables;
close all;

%% Initialisation des variables
fichier_mire='img/img169.jpg';

%% Extraction des points 3D et des points image
[ points_monde, points_image ] = extraction_points_mire( fichier_mire );
[ points_image ] = minimisation_erreur_projection( points_monde, points_image );

% while erreur_projection > 1
%     [ points_monde, points_image ] = extraction_points_mire( fichier_mire , points_monde );
%     [ points_image, erreur_projection ] = minimisation_erreur_projection( points_monde, points_image );
% end

%% Résolution du problème
[ matrice_projection ] = calcul_matrice_projection_dlt( points_monde , points_image );
[ points_image_projete ] = projection_points( points_monde , matrice_projection );
[ erreur_projection ] = calcul_erreur_projection( points_image , points_image_projete );

%% Affichage des nouveaux points projeté via la matrice de projection
figure;
imshow(fichier_mire);
hold on;
for i=1:length(points_image)
    plot(points_image(1,i),points_image(2,i),'ob');
    plot(points_image_projete(1,i),points_image_projete(2,i),'*r');
end
clear i;

save('mp_camera.mat','matrice_projection');