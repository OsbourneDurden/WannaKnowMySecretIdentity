function [ matrice_projection ] = calcul_matrice_projection_dlt( points_monde , points_image )
%% Calcul de la matrice de projection via DLT
%
% INPUT : [points_monde, points_image] o� points_monde est une matrice
% N*3 de points dans le monde, et points_image est une matrice de N*2 
% points dans le plan image
% OUTPUT : Matrice de projection 4*3 du syst�me
%
% On calcule la matrice A du probl�me et on trouve la solution des moindres
% carr�s via la fonction svd.

%% Initialisation des variables
N=length(points_monde);
Mi=vertcat(points_monde, ones(1,N));
mi=points_image;
A=zeros(2*N,12);

%% Initialisation de A
for i=1:N
    A(2*i-1,:)=[zeros(1,4) -Mi(:,i)' mi(2,i)*Mi(:,i)' ];
    A(2*i,:)=[Mi(:,i)' zeros(1,4) -mi(1,i)*Mi(:,i)' ];
end

%% R�solution du syst�me
[~,~,V]=svd(A);
matrice_projection=reshape(V(:,end)/V(end,end),4,3)';

end