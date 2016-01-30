function [ points_monde, points_image ] = extraction1_points_mire( fichier_mire )
%% Choix de points d'une mire
%
% INPUT : chemin d'un fichier de type mire
% OUTPUT : [points_monde, points_image] o� points_monde est une matrice
% N*3 de points dans le monde, et points_image est une matrice de N*2 
% points dans le plan image
%
% On demande un nombre de points � extraire, on entre ses coordonn�es
% x y z s�par�s par un espace, puis on va sur la figure de la mire
% choisir les points

%% Initialisation des variables et affichage de la mire
N=input('Nombre de points � extraire : '); %nb points
points_monde=zeros(3,N);
points_image=zeros(2,N);
figure(1);
imshow(fichier_mire); % imshow ne permet pas de d�former les pixels

%% Choix utilisateur des points
for i=1:N
    commandwindow;
    strcoord=input(['Entrez les coordonn�es', ...
        ' x, y et z du point ', num2str(i), ' : '],'s');
    points_monde(:,i)=str2num(strcoord);
    disp('Zoomez et s�lectionnez le point sur le graphique');
    figure(1)
    title(['Zoomez sur le point ', num2str(i), ' de coordonn�es ', strcoord]);
    pause;
    title(['Selectionnez le point ', num2str(i), ' de coordonn�es ', strcoord]);
    [points_image(1,i), points_image(2,i)] = ginput();
    zoom out;
end
close(1);
save('points.mat', 'points_monde','points_image');
end