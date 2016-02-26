function [ matrice_K ] = parametres_intrinseques( matrice_projection )
%% Calcul des paramètres intrinsèques de la matrice de projection
% decomposition qr etc etc.
% signes
% homogene

[~,R] = qr(flipud(matrice_projection(:,1:3))');
R = rot90(R',2);
signes_R = diag(sign(diag(R)));
R = R * signes_R;
matrice_K = R./R(end);

end

