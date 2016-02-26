clear all;
close all;

load('workspace.mat')
[ M, K, ~, ~ ] = calcul_matrice_projection_dlt( points_monde , points_image.*1 )

[ M, K, ~, ~ ] = calcul_matrice_projection_dlt( points_monde , points_image.*0.5 )

temp = points_image(1,:);
points_image(1,:) = points_image(2,:);
points_image(2,:) = temp;

[ M, K, ~, ~ ] = calcul_matrice_projection_dlt( points_monde , points_image.*1 )

[ M, K, ~, ~ ] = calcul_matrice_projection_dlt( points_monde , points_image.*0.5 )
