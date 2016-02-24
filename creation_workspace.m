function [ points_monde, points_image ] = creation_workspace()
%%  Mise en place des points 3D et des points_images de la mire gauche et droite
%
% INPUT : []
% OUTPUT : [points_monde, points_image_D, points_image_G] o� points_monde 
% est une matrice N*3 de points dans le monde, et points_image_D ou G sont
% des matrices de N*2  points dans le plan image correspondant pour D � la
% vue droite et G � la vue gauche
%
% On va charger le workspace s'il � d�j� �t� cr�e, sinon on demande �
% l'utilisateur d'extraire des points de la mire en vue droite, puis on
% cherche � r�-extraire ces m�mes points dans la vue gauche. Enfin on
% minimise l'erreur de l'utilisateur (pr�cision de la s�lection des pixels)
% et on enregistre le r�sultat dans un fichier workspace.mat

if exist('workspace.mat','file')
    K = menu('Fichier workspace.mat existe d�j�', ...
        'Refaire les points 3D, et points_image de la mire', ...
        'Charger les donn�es existantes');
    if K == 1
        if exist('workspace.mat.old','file')
            delete('workspace.mat.old');
        end
        movefile('workspace.mat','workspace.mat.old')
        [ points_monde, points_image ] = creation_workspace();
    elseif K == 2
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
        [ points_monde, points_image ] = extraction_points_mire( fichier_mire , points_monde );
        [ points_image, erreur_projection ] = minimisation_erreur_projection( points_monde, points_image );
        cond = erreur_projection > 1;
    end

    %% R�solution du probl�me
    [ matrice_projection, K, R, T ] = calcul_matrice_projection_dlt( points_monde , points_image );

    %% Affichage des nouveaux points projet� via la matrice de projection
    fig = figure;
    imshow(fichier_mire);
    hold on;
    for i=1:length(points_image)
        plot(points_image(1,i),points_image(2,i),'ob');
        plot(points_image_projete(1,i),points_image_projete(2,i),'*r');
    end
    clear i;
    pause;
    close(fig);

    save('workspace.mat','K');
    
end