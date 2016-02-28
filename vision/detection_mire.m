function [ points_plan_xoy, points_image, s ] = detection_mire( img )
%% Detection d'une mire (damier) dans une image
%
% INPUT : [img] où img est une image RGB
% OUTPUT : [ points_plan_xoy, points_image, s ] où points_plan_xoy est une 
% matrice de 2*N points dans le plan xOy, points_image est une matrice de 
% N*2 points dans le plan focal, et s la taille du damier.
%
% On utilise ici la fonction detectCheckerboardPoints de la toolbox vision
% de Matlab. Celle-ci rend les points entre les carrés d'un damier, dans un 
% ordre auquel on peut etrouver les points_plan_xoy correspondant. 
% On crée une matrice de ces points dans le même ordre.
% 
% Ordre des points de la fonction detectCheckerboardPoints :
% http://fr.mathworks.com/help/releases/R2015b/vision/ref/checkerboard_detect.png
%
% References:
% -----------
% Andreas Geiger, Frank Moosmann, Omer Car, and Bernhard Schuster, 
% "Automatic Camera and Range Sensor Calibration using a single Shot. 
% In International Conference on Robotics and Automation (ICRA), St. Paul, 
% USA, May 2012.

%% Initialisation des variables
points_plan_xoy = [];
points_image = [];
[points, s] = detectCheckerboardPoints(img);

%% On retire les warnings générés
[~, MSGID] = lastwarn();
if ~isempty(MSGID)
    warning('off', MSGID);
end

%% Si on détecte un damier, on résoud le problème 
if max(s) ~= 0
    points_plan_xoy = vertcat( repmat( 1:s(1)-1, 1, s(2)-1 ), ...
        reshape( repmat( 1:s(2)-1, s(1)-1, 1 ), 1, prod(s-1) ));
    points_image = points';
end

