function [ K ] = calcul_proprietes_intrinseques_camera()
%%  Calcul des propriétés intrinsèques de la caméra
%
% INPUT : []
% OUTPUT : K est une matrice 3*3 de coordonées intrinsèques d'une 
% caméra (ici diagonale supérieure)
%
% On va charger le workspace s'il à déjà été crée, sinon on demande à
% l'utilisateur d'extraire des points de la mire. Enfin on
% minimise l'erreur de reprojection l'utilisateur (précision de la 
% sélection des pixels). On calcule ensuite la matrice de projection dont 
% on extrait les paramètres intrinsèques et on enregistre le résultat 
% dans un fichier workspace.mat

if exist('workspace.mat','file')
    choice = menu('Fichier workspace.mat existe déjà', ...
        'Refaire les points 3D, et points_image de la mire', ...
        'Charger les données existantes');
    if choice == 1
        if exist('workspace.mat.old','file')
            delete('workspace.mat.old');
        end
        movefile('workspace.mat','workspace.mat.old')
        [ K ] = calcul_proprietes_intrinseques_camera ();
    elseif choice == 2
        load('workspace.mat');
    end
else
%% Initialisation des variables
fichier_mire='etc/img169.jpg';

%% Extraction des points 3D et des points image
[ points_monde, points_image ] = extraction_points_mire( fichier_mire );
[ points_image, erreur_projection ] = minimisation_erreur_projection( points_monde, points_image );
cond = erreur_projection > 1;
while cond
    fprintf(['Erreur de projection trop grande (%d pixels), ' ...
        're-selectionnez les points images svp :\n'], erreur_projection)
    [ points_monde, points_image ] = extraction_points_mire( fichier_mire , points_monde );
    [ points_image, erreur_projection ] = minimisation_erreur_projection( points_monde, points_image );
    cond = erreur_projection > 1;
end

%% Résolution du problème
[ K ] = parametres_intrinseques( dlt( points_monde , points_image ) );

%% Affichage des nouveaux points projeté via la matrice de projection
fig = figure;
imshow(fichier_mire);
hold on;
for i = 1:length(points_image)
    plot( points_image(1,i), points_image(2,i), 'ob' );
    plot( points_image_projete(1,i), points_image_projete(2,i), '*r' );
end
clear i;
pause;
close(fig);

save( 'workspace.mat', 'K' );
    
end