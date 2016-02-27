function [ K ] = parametres_intrinseques( matrice_projection )
%% Calcul des paramètres intrinsèques de la matrice de projection
%
% INPUT : [matrice_projection], une matrice 4*3 de projection du système 
% dans le plan focal.
% OUTPUT : [ K ] où K est une matrice 3*3 de coordonées intrinsèques d'une 
% caméra (ici diagonale supérieure)
%
% On fait une décomposition qr de KR (les trois premières colonnes de la
% matrice de projection), puis on la retourne dans le bon sens.
% On la normalise, et on fait aussi en sorte que sa diagonale soit composée
% d'elements positifs (étant donné que cela représente les coorodnéés de la
% distance focale).

%% Résolution du problème
[ ~, R ] = qr( flipud( matrice_projection(:,1:3) )' );
R = rot90( R', 2 );
K = R * diag( sign( diag(R) ) ) ./ R(end);

end
