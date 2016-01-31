function [ points_monde, points_image_D, points_image_G ] = creation_workspace()
%%  Mise en place des points 3D et des points_images de la mire gauche et droite
%
% INPUT : []
% OUTPUT : [points_monde, points_image_D, points_image_G] où points_monde 
% est une matrice N*3 de points dans le monde, et points_image_D ou G sont
% des matrices de N*2  points dans le plan image correspondant pour D à la
% vue droite et G à la vue gauche
%
% On va charger le workspace s'il à déjà été crée, sinon on demande à
% l'utilisateur d'extraire des points de la mire en vue droite, puis on
% cherche à ré-extraire ces mêmes points dans la vue gauche. Enfin on
% minimise l'erreur de l'utilisateur (précision de la sélection des pixels)
% et on enregistre le résultat dans un fichier workspace.mat

if exist('workspace.mat','file')
    K = menu('Fichier workspace.mat existe déjà', ...
        ['Refaire les points 3D, et points_image de la mire,', ... 
        'vue gauche et droite'], ...
        'Charger les données existantes');
    if K == 1;
        if exist('workspace.mat.old','file')
            delete('workspace.mat.old');
        end
        movefile('workspace.mat','workspace.mat.old')
        [ points_monde, points_image_D, points_image_G ] = creation_workspace();
    end
    
else
    %% Initialisation des variables
    fichier_mire='img/vue droite0.png';
    fichier_mire2='img/vue gauche0.png';

    %% Extraction des points 3D et des points image
    [ points_monde, points_image_D ] = extraction_points_mire( fichier_mire );
    [ ~, points_image_G ] = extraction_points_mire( fichier_mire2 , points_monde );

    %% Résolution du problème
    [ points_image_D ] = minimisation_erreur_projection( points_monde, points_image_D );
    [ points_image_G ] = minimisation_erreur_projection( points_monde, points_image_G );

    save( 'workspace.mat', 'points_monde', 'points_image_D', 'points_image_G' );
end