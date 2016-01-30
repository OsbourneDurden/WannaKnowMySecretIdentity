function [ points_monde, points_image_D, points_image_G ] = creation_workspace()

if exist('workspace.mat','file')
    load('workspace.mat');
else
    cond=2;
    while cond < 1
        %% Initialisation des variables
        fichier_mire='img/vue droite0.png';
        fichier_mire2='img/vue gauche0.png';

        %% Extraction des points 3D et des points image
        [ points_monde, points_image_D ] = extraction_points_mire( fichier_mire );
        [ ~, points_image_G ] = extraction_points_mire( fichier_mire2 , points_monde );

        %% Résolution du problème
        [ matrice_projection_D ] = calcul_matrice_projection_dlt( points_monde , points_image_D );
        [ points_image_D_projete ] = projection_points( points_monde , matrice_projection_D );
        [ erreur_projection_D ] = calcul_erreur_projection( points_image_D , points_image_D_projete );
        [ matrice_projection_G ] = calcul_matrice_projection_dlt( points_monde , points_image_G );
        [ points_image_G_projete ] = projection_points( points_monde , matrice_projection_G );
        [ erreur_projection_G ] = calcul_erreur_projection( points_image_G , points_image_G_projete );

        %% Test de la précision du système à enregistrer
        cond = erreur_projection_D + erreur_projection_G;
        
        if cond >= 1
            disp('Les points sont pas bons, réesayez :-D');
        end
        
    end
    save( 'workspace.mat', 'points_monde', 'points_image_D', 'points_image_G' );
end