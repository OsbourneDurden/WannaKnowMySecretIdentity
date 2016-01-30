function [ points_monde, points_image ] = extraction_points_mire( fichier_mire, varargin )
%% Choix de points d'une mire
%
% INPUT : chemin d'un fichier de type mire, possibilit� de mettre en second
% argument une matrice N*3 de points dans le monde
% OUTPUT : [points_monde, points_image] o� points_monde est une matrice
% N*3 de points dans le monde, et points_image est une matrice de N*2 
% points dans le plan image
%
% On demande un nombre de points � extraire, on entre ses coordonn�es
% x y z s�par�s par un espace, puis on va sur la figure de la mire
% choisir les points. Si on a d�j� une matrice de points dans le monde, on
% peux mettre la variable en input et la fonction utilisera cette matrice.
% 
% La fonction enregistre dans un fichier (r�f�renc� avec le nom de la mire)
% les variables points_monde et points_image.

%% Initialisation des variables et affichage de la mire
if nargin == 1
    % Si on a pas de points_monde, on demande � l'utilisateur de la
    % cr�er
    N=input('Nombre de points � extraire : ');
    points_monde=zeros(3,N);
elseif nargin == 2
    % Sinon, on r�cup�re points_monde
    size_arg=size(varargin{1});
    if size_arg(1) ~= 3
       error('Mauvais format du deuxi�me argument');
    end
    points_monde=varargin{1};
    N=length(points_monde);
else
    error('Nombre d''arguments incorrect');
end

points_image=zeros(2,N);
figure(1);
imshow(fichier_mire); % imshow ne permet pas de d�former les pixels

%% Choix utilisateur des points sur la mire
for i=1:N
    if nargin == 1
        % Si on a pas de points_monde, on demande � l'utilisateur de la
        % cr�er
        commandwindow;
        coord=0;
        while length(coord) ~= 3
            coord=str2num(input(['Entrez les coordonn�es x, y et z ', ... 
                'du point ', num2str(i), ' s�par�s par un espace : '],'s'));
            if length(coord) ~= 3
               disp('Nombre d''arguments incorrect, r�esayez');
            end
        end
        points_monde(:,i)=coord;
        disp('Zoomez et s�lectionnez le point sur le graphique');
    elseif nargin == 2
        % Si on a points_monde, on a directement les coordon�es pour chaque
        % point
        coord=points_monde(:,i)';
    end
    
    strcoord=['x=', num2str(coord(1)), ', y=', num2str(coord(2)), ...
        ' et z=', num2str(coord(3))];
    figure(1)
    title(['Zoomez sur le point ', num2str(i), ' de coordonn�es ', strcoord]);
    pause;
    title(['Selectionnez le point ', num2str(i), ' de coordonn�es ', strcoord]);
    [points_image(1,i), points_image(2,i)] = ginput();
    zoom out;
end

close(1);
save(['points-', fichier_mire, '.mat'], 'points_monde','points_image');

end

