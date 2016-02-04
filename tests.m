fichier_mire='img/img169.jpg';

[ matrice_projection ] = calcul_matrice_projection_dlt( points_monde , points_image );
[ points_image_projete ] = projection_points( points_monde , matrice_projection );

figure;
imshow(fichier_mire);
hold on;
for i=1:length(points_image)
    plot(points_image(1,i),points_image(2,i),'ob');
    plot(points_image_projete(1,i),points_image_projete(2,i),'*r');
end
clear i;