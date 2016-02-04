%% Initialisation du workspace
clear variables;
close all;

%% Initialisation des variables
fichier_mire = 'img/vue droite0.png';
load('workspace.mat');
points_image = points_image_D;
clear points_image_D points_imageG;

%% Résolution du problème
[ ~, K, R, T ] = calcul_matrice_projection_dlt( points_monde , points_image );
matrice_projection = K * [R T];
[ points_image_projete ] = projection_points( points_monde , matrice_projection );
[ erreur_projection ] = calcul_erreur_projection( points_image , points_image_projete );

%% Affichage des nouveaux points projeté via la matrice de projection
figure;
imshow(fichier_mire);
hold on;
for i=1:length(points_image)
    plot(points_image_projete(1,i),points_image_projete(2,i),'*r');
end
clear i;