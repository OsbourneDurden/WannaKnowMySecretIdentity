close all;
clear variables;

%% Initialisation du workspace
addpath( genpath(pwd) ); % les sous-dossiers du projet seront inclus au path
load( 'workspace' ) % r�cup�ration des propri�t�s intrins�ques de la cam�ra
scale = 1; % scale est un facteur de retr�cissement des images � traiter
load( 'etc/porsche.mat' ); % r�cup�ration du mod�le � ajouter

%% Initialisation de la vid�o
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

% On doit redimensionner la matrice K (homog�ne) pour qu'elle corresponde �
% la r�solution de la vid�o
size_plan_mire = size( imread('etc/img169.jpg') );
K = redimensionnement_parametres_intriseques( K, size_plan_mire, size(video2) );

%% Bouclage tant que la vid�o contient des frames
while hasFrame( v )
    video = readFrame( v );
    video2 = imresize( video, 1/scale, 'nearest' );
    % Ici on va tenter de d�tecter la mire
    [ pts_monde, points, s ] = detection_mire( video2 );
    if max(s) ~= 0 % Si la mire est d�tect�e   
        %% R�solution du probl�me
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
        % Affichage de la nouvelle position du mod�le
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
