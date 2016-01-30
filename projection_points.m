function [ points_image ] = projection_points( points_monde , matrice_projection )
%% Projection de points "monde" dans un plan image
%
% INPUT : [points_monde, matrice_projection] où points_monde est une matrice
% N*3 de points dans le monde, et matrice_projection une matrice 4*3 de
% projection du système dans un plan
% OUTPUT : [points_image] où points_image est une matrice de N*2 points dans 
% le plan image
%
% On calcule pour chaque point du monde le point dans le plan image déifni
% par la matrice de projection

%% Initialisation des variables
P=matrice_projection;
N=length(points_monde);
Mi=vertcat(points_monde, ones(1,N));
Y=zeros(3,N);
Mp=zeros(2,N);

%% Calcul de chaque point dans le plan image
for i=1:N
    Y(:,i) = P * Mi(:,i);
    Mp(:,i) = Y(1:2,i)/Y(3,i);
end
points_image=Mp;

end

