function [ new_vertices ] = centrer_modele_sur_mire( vertices, s )
%% Recentrage d'un modèle sur une mire
%
% INPUT : [vertices, s] où vertices est une matrice N*3 de sommets dans le 
% monde, et s une matrice 2*1 correspondant à la taille du damier.
% OUTPUT : [new_vertices], matrice N*3 de sommets dans le 
% monde
%
% La reconnaissance du damier rend sa taille, ou le deuxième élément est le
% plus grand. Suivant si le point le plus éloigné de l'axe z du modele est
% sur x ou y, on effectue une rotation du modèle, et on redimensionne
% celui-ci pour qu'il s'intègre parfaitement dans le damier.

maxs = max(abs(vertices));
if max( maxs(1:2) ) == maxs(1)
    new_vertices = [ vertices(:,2) ...
    vertices(:,1) vertices(:,3) ];
    scale = max(maxs) ./ (s(2)+1) .* 2;
else
    new_vertices = [ vertices(:,1) ...
    vertices(:,2) vertices(:,3) ];
    scale = max(maxs) ./ (s(1)+1) .* 2;
end

new_vertices = new_vertices ./ scale;
new_vertices(:,1) = new_vertices(:,1) + s(1) ./ 2;
new_vertices(:,2) = new_vertices(:,2) + s(2) ./ 2;

end
