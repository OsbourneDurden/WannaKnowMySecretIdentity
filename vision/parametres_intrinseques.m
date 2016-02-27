function [ K ] = parametres_intrinseques( matrice_projection )
%% Calcul des param�tres intrins�ques de la matrice de projection
%
% INPUT : [matrice_projection], une matrice 4*3 de projection du syst�me 
% dans le plan focal.
% OUTPUT : [ K ] o� K est une matrice 3*3 de coordon�es intrins�ques d'une 
% cam�ra (ici diagonale sup�rieure)
%
% On fait une d�composition qr de KR (les trois premi�res colonnes de la
% matrice de projection), puis on la retourne dans le bon sens.
% On la normalise, et on fait aussi en sorte que sa diagonale soit compos�e
% d'elements positifs (�tant donn� que cela repr�sente les coorodn��s de la
% distance focale).

%% R�solution du probl�me
[ ~, R ] = qr( flipud( matrice_projection(:,1:3) )' );
R = rot90( R', 2 );
K = R * diag( sign( diag(R) ) ) ./ R(end);

end
