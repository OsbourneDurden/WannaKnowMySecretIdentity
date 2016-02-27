function [ new_K ] = redimensionnement_parametres_intriseques( K, size_mire, size_frame )
%% Redimensionnement des paramètres intrinsèques d'une caméra
%
% INPUT : [ K, size_mire, size_frame ] où K est une matrice 3*3
% correpondant aux paramètres intrinsèques de la caméra, size_mire la
% résolution du fichier utilisé pour calibrer la caméra, et size_frame la
% résolution de la frame sur lequel on veut appliquer K.
% OUTPUT : [ new_K ] où new_K est une matrice 3*3 correpondant aux 
% paramètres intrinsèques de la caméra.
%
% La matrice K étant homogène, elle est définit à un ordre de grandeur
% près. Ici cet ordre de grandeur est la dimension de l'image (partie du
% plan focal) utilisé pour connaitre les paramètres intrinsèques de la
% caméra. Pour appliquer K sur d'autres résolution que celle initiale, on
% doit redimensionner K (coordonées de la distance focale et du point
% focal). 

%% Résolution du problème.
new_K = K / size_mire(2) * size_frame(2);
new_K(end) = 1;

end

