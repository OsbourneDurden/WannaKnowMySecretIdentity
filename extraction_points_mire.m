function [ points_monde, points_image ] = extraction_points_mire( fichier_mire, varargin )
%% Choix de points d'une mire
%
% INPUT : chemin d'un fichier de type mire, possibilité de mettre en second
% argument une matrice N*3 de points dans le monde
% OUTPUT : [points_monde, points_image] où points_monde est une matrice
% N*3 de points dans le monde, et points_image est une matrice de N*2 
% points dans le plan image
%
% On demande un nombre de points à extraire, on entre ses coordonnées
% x y z séparés par un espace, puis on va sur la figure de la mire
% choisir les points. Si on a déjà une matrice de points dans le monde, on
% peux mettre la variable en input et la fonction utilisera cette matrice.
% 
% La fonction enregistre dans un fichier (référencé avec le nom de la mire)
% les variables points_monde et points_image.

%% Initialisation des variables et affichage de la mire
if nargin == 1
    % Si on a pas de points_monde, on demande à l'utilisateur de la
    % créer
    N=input('Nombre de points à extraire : ');
    points_monde=zeros(3,N);
elseif nargin == 2
    % Sinon, on récupère points_monde
    size_arg=size(varargin{1});
    if size_arg(1) ~= 3
       error('Mauvais format du deuxième argument');
    end
    points_monde=varargin{1};
    N=length(points_monde);
else
    error('Nombre d''arguments incorrect');
end

points_image=zeros(2,N);
figure(1);
imshow(fichier_mire); % imshow ne permet pas de déformer les pixels

%% Choix utilisateur des points sur la mire
for i=1:N
    if nargin == 1
        % Si on a pas de points_monde, on demande à l'utilisateur de la
        % créer
        commandwindow;
        coord=0;
        while length(coord) ~= 3
            coord=str2num(input(['Entrez les coordonnées x, y et z ', ... 
                'du point ', num2str(i), ' séparés par un espace : '],'s'));
            if length(coord) ~= 3
               disp('Nombre d''arguments incorrect, réesayez');
            end
        end
        points_monde(:,i)=coord;
        disp('Zoomez et sélectionnez le point sur le graphique');
    elseif nargin == 2
        % Si on a points_monde, on a directement les coordonées pour chaque
        % point
        coord=points_monde(:,i)';
    end
    
    strcoord=['x=', num2str(coord(1)), ', y=', num2str(coord(2)), ...
        ' et z=', num2str(coord(3))];
    figure(1)
    title(['Zoomez sur le point ', num2str(i), ' de coordonnées ', strcoord]);
    pause;
    title(['Selectionnez le point ', num2str(i), ' de coordonnées ', strcoord]);
    [points_image(1,i), points_image(2,i)] = ginput();
    zoom out;
end

close(1);
save(['points-', fichier_mire, '.mat'], 'points_monde','points_image');

end

