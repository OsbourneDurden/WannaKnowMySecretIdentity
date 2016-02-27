function [ model ] = ply_to_patch( filename )
%% Conversion d'un fichier en format de fichier polygone en structure
%
% INPUT : chemin d'un fichier de type polygone (.ply)
% OUTPUT : model, structure contenant les vertex, et les faces
%
% On lit le fichier .ply avec la fonction plyread (de Pascal Getreuer) puis
% On mets en forme les données pour obtenir une structure "model", où, lors
% d'un appel à patch, celui-ci prendra comme vertices model.vertex et comme
% faces model.patch. On le rend également dans une matrice.

%% On lit le fichier
mod = plyread(filename);

%% Initialisation des variables (structure)
vertex = [mod.vertex.x mod.vertex.y mod.vertex.z];
faces = zeros(length(mod.face.vertex_indices),3);

%% Mise en forme
for i=1:length(mod.face.vertex_indices)
    faces(i,:)=mod.face.vertex_indices{i};
end
faces = faces+1;

%% On rend la structure composé des nouveaux vertices et faces
model = struct('vertex',vertex,'faces',faces);
save([filename(1:end-4) '.mat'], 'model');

end
