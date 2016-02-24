function [ matrice_homographie ] = calcul_matrice_homographie_dlt( points_monde , points_image )
%% Calcul de la matrice d'homographie via DLT


%% Initialisation des variables
N = length(points_monde);
Mi = vertcat(points_monde, ones(1,N));
mi = points_image;
A = zeros(2*N,9);

%% Initialisation de A
for i=1:N
    A(2*i-1,:)=[zeros(1,3) -Mi(:,i)' mi(2,i)*Mi(:,i)' ];
    A(2*i,:)=[Mi(:,i)' zeros(1,3) -mi(1,i)*Mi(:,i)' ];
end

%% Résolution du système ||A*X|| = 0
[~,~,V] = svd(A);
X=V(:,end);
matrice_homographie = reshape(X/X(end),3,3)';

end
