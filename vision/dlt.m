function [ matrice_resultante ] = dlt( points_monde , points_image )
%% Calcul de la matrice de projection via DLT
%
% INPUT : [points_monde, points_image] où "points_monde" est une matrice
% dim*N de points dans le monde, et "points_image" est une matrice de 2*N 
% points dans le plan image
% OUTPUT : Matrice dim*3 du système
%
% On calcule la matrice A du problème et on trouve la solution des moindres
% carrés via la fonction svd. Si les points_monde ont 3 composantes, on aura
% en sortie une matrice de projection (12 paramètres), sinon si les
% points_monde ont 2 composantes, on aura une matrice d'homographie (plan).
%
% Par défaut, si les points_monde ont deux composantes, on va donc
% travailler avec le plan xOy pour le calcul d'homographie.

%% Initialisation des variables
[ nb_dim, N ] = size( points_monde );
dim = nb_dim + 1;
Mi = vertcat( points_monde, ones(1,N) );
mi = points_image;
A = zeros( 2 * N, 3 * dim );

%% Initialisation de A
for i = 1:N
    A( 2*i-1, : )  = [ zeros(1,dim) -Mi(:,i)' mi(2,i)*Mi(:,i)' ];
    A( 2*i, : ) = [ Mi(:,i)' zeros(1,dim) -mi(1,i)*Mi(:,i)' ];
end

%% Résolution du système ||A*X|| = 0
[ ~, ~, V ] = svd(A);
X = V(:,end);
matrice_resultante = reshape( X / X(end) , dim , 3 )';

end
