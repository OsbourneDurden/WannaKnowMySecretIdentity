function [ P2D ] = projection_3D_2D( K, H )
%% Calcul d'une matrice de projection
%
% INPUT : [K, H] où K est une matrice 3*3 de coordonées intrinsèques d'une 
% caméra (ici diagonale supérieure), et H une matrice 3*3 d'homographie du 
% plan xOy vers un nouveau plan
% OUTPUT : [P2D], une matrice 4*3 de projection du système dans le plan
% focal.
%
% Le pseudo-code de cette fonction à été donné lors du cours de vision de
% Sio Hoi Ieng, c'est la deuxième question posée de la partie 2 : Modèle
% géométrique d'une caméra

%% Données du problème
P = K \ H; % mldivide
R1 = P(:,1);
R2 = P(:,2);
R3 = cross( R1, R2 ); % R3 = R1 ^ R2
alpha = det([ R1 R2 R3 ])^0.25; % Racine quatrième

% Normalement, il faut tester alpha avec le P2D reconstruit, étant donné
% qu'il y a une ambiguité. 
% Notre matrice K mise en entrée est issue d'une décomposition rq, mais on
% a pris soin d'avoir en paramètres une distance focale correcte. Alpha
% doit donc être positif.

%% Reconstruction de la matrice de projection
P2D = K * [R1 R2 R3/alpha P(:,3)] / alpha; 
P2D = P2D / P2D(end,end);

end
