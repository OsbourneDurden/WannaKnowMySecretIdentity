function [ Q, R ] = decomposition_qr_householder( A )
%% Calcul des matrices Q et R décomposant A via la méthode de Householder
%
% INPUT : A matrice 3*3
% OUTPUT : Q matrice 3*3 et R matrice 3*3 triangulaire supérieure
%
% http://onlinelibrary.wiley.com/doi/10.1002/9780470316757.app2/pdf

%% Calcul de Q1
a1=sign(A(1))*norm(A(:,1)');
u=A(:,1)';
u(1)=u(1)-a1;
v=u/norm(u);
Q1=eye(3)-2*(v'*v);

%% Calcul de A'
Q1A=Q1*A;
A_prime=Q1A(2:end,2:end);

%% Calcul de Q2
a2=sign(A_prime(1))*norm(A_prime(:,1)');
u2=A_prime(:,1)';
u2(1)=u2(1)-a2;
v2=u2/norm(u2);
Q2=eye(3);
Q2(2:end,2:end)=eye(2)-2*(v2'*v2);

%% On en déduit Q et R
Q=(Q1*Q2);
R=Q'*A;

end
