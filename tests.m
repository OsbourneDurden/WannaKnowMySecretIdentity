<<<<<<< HEAD
fichier_mire='img/img169.jpg';

[ matrice_projection ] = calcul_matrice_projection_dlt( points_monde , points_image );
[ points_image_projete ] = projection_points( points_monde , matrice_projection );

=======
%% Initialisation du workspace
clear variables;
close all;

%% Initialisation des variables
fichier_mire = 'img/vue droite0.png';
load('workspace.mat');
points_image = points_image_D;
clear points_image_D points_imageG;

%% Résolution du problème
[ matrice_projection, ~, ~, ~ ] = calcul_matrice_projection_dlt( points_monde , points_image );
[ points_image_projete ] = projection_points( points_monde , matrice_projection );
[ erreur_projection ] = calcul_erreur_projection( points_image , points_image_projete );

%% Affichage des nouveaux points projeté via la matrice de projection
>>>>>>> refs/remotes/origin/master
figure;
imshow(fichier_mire);
hold on;
for i=1:length(points_image)
<<<<<<< HEAD
    plot(points_image(1,i),points_image(2,i),'ob');
=======
>>>>>>> refs/remotes/origin/master
    plot(points_image_projete(1,i),points_image_projete(2,i),'*r');
end
clear i;