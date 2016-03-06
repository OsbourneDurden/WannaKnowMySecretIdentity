close all;
clear variables;

%% Initialisation du workspace
addpath( genpath(pwd) ); % les sous-dossiers du projet seront inclus au path
load( 'workspace' ) % récupération des propriétés intrinsèques de la caméra
scale = 1; % scale est un facteur de retrécissement des images à traiter
load( 'etc/porsche.mat' ); % récupération du modèle à ajouter

%% Initialisation de la vidéo
v = VideoReader( 'etc/situation_2.mp4' );
%nb_Frames1 = floor(v.Duration*v.FrameRate);

%% Initialisation des variables, et du plotting
video = readFrame( v );
video2 = imresize( video, 1/scale, 'nearest' );
h = imshow( video2 );
hold on;
pt = [];
pl = [];
pl2 = [];
drawnow;

% On doit redimensionner la matrice K (homogène) pour qu'elle corresponde à
% la résolution de la vidéo
size_plan_mire = size( imread('etc/img169.jpg') );
K = redimensionnement_parametres_intriseques( K, size_plan_mire, size(video2) );

%% Bouclage tant que la vidéo contient des frames
while hasFrame( v )
    video = readFrame( v );
    video2 = imresize( video, 1/scale, 'nearest' );
    % Ici on va tenter de détecter la mire
    [ pts_monde, points, s ] = detection_mire( video2 );
    if max(s) ~= 0 % Si la mire est détectée   
        %% Résolution du problème
        H = dlt( pts_monde , points ); % Homographie
        P2 = projection_3D_2D( K, H ); % Calcul de la matrice de projection
        [ new_vertex ] = centrer_modele_sur_mire( model.vertex, s );
        [ new_vertex ] = projection_points( new_vertex' , P2 );
        
        delete( pt );
        delete( pl );
        delete( pl2 );
        
        % Affichage des coins du damier
        pl = plot( points(1,:), points(2,:), '*b' );
        % Affichage du point monde (1,1,0)
        pl2 = plot( points(1,1), points(2,1), 'or');
        % Affichage de la nouvelle position du modèle
        pt = patch( 'Faces', model.faces, 'Vertices', new_vertex', ...
            'FaceColor', 'none', 'EdgeColor', 'red' );
        
    else
        delete( pt );
        delete( pl );
        delete( pl2 );
    end
    % Affichage de la nouvelle frame
    set( h, 'Cdata', video2 );
    drawnow;
end
