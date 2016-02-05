function [Q, R] = decomposition_qr(A)
%% Calcul des matrices Q et R décomposant A 
% Calcul Q et R, avec une petite subtilité, R sera forcément doté d'une
% diagonale positive 
%
% INPUT : A matrice 3*3
% OUTPUT : Q matrice 3*3 et R matrice 3*3 triangulaire supérieure

[Q,R] = qr(flipud(A)');
R = rot90(R',2);
Q = flipud(Q');
signes_R = diag(sign(diag(R)));
R = R * signes_R;
Q = signes_R' * Q;

end
