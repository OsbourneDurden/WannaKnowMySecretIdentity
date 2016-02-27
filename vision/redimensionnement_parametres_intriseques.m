function [ new_K ] = redimensionnement_parametres_intriseques( K, size_mire, size_frame )
%% Redimensionnement des param�tres intrins�ques d'une cam�ra
%
% INPUT : [ K, size_mire, size_frame ] o� K est une matrice 3*3
% correpondant aux param�tres intrins�ques de la cam�ra, size_mire la
% r�solution du fichier utilis� pour calibrer la cam�ra, et size_frame la
% r�solution de la frame sur lequel on veut appliquer K.
% OUTPUT : [ new_K ] o� new_K est une matrice 3*3 correpondant aux 
% param�tres intrins�ques de la cam�ra.
%
% La matrice K �tant homog�ne, elle est d�finit � un ordre de grandeur
% pr�s. Ici cet ordre de grandeur est la dimension de l'image (partie du
% plan focal) utilis� pour connaitre les param�tres intrins�ques de la
% cam�ra. Pour appliquer K sur d'autres r�solution que celle initiale, on
% doit redimensionner K (coordon�es de la distance focale et du point
% focal). 

%% R�solution du probl�me.
new_K = K / size_mire(2) * size_frame(2);
new_K(end) = 1;

end

