function [ points_plan_xoy, points_image, s ] = detection_mire( img )
%% Detection d'une mire (damier) dans une image
%
% INPUT : [img] o� img est une image RGB
% OUTPUT : [ points_plan_xoy, points_image, s ] o� points_plan_xoy est une 
% matrice de 2*N points dans le plan xOy, points_image est une matrice de 
% N*2 points dans le plan focal, et s la taille du damier.
%
% On utilise ici la fonction detectCheckerboardPoints de la toolbox vision
% de Matlab. Celle-ci rend les points entre les carr�s d'un damier, dans un 
% ordre auquel on peut etrouver les points_plan_xoy correspondant. 
% On cr�e une matrice de ces points dans le m�me ordre.

%% Initialisation des variables
points_plan_xoy = [];
points_image = [];
[points, s] = detectCheckerboardPoints(img);

%% On retire les warnings g�n�r�s
[~, MSGID] = lastwarn();
if ~isempty(MSGID)
    warning('off', MSGID);
end

%% Si on d�tecte un damier, on r�soud le probl�me 
if max(s) ~= 0
    points_plan_xoy = vertcat( repmat( 1:s(1)-1, 1, s(2)-1 ), ...
        reshape( repmat( 1:s(2)-1, s(1)-1, 1 ), 1, prod(s-1) ));
    points_image = points';
end

