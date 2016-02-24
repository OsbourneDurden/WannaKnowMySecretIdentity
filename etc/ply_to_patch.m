function [ model ] = ply_to_patch( filename, scale )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

mod = plyread(filename);
vertex = [mod.vertex.x mod.vertex.y mod.vertex.z];
faces = zeros(length(mod.face.vertex_indices),3);
for i=1:length(mod.face.vertex_indices)
    faces(i,:)=mod.face.vertex_indices{i};
end
vertex =  vertex .* scale;
faces = faces+1;

model = struct('vertex',vertex,'faces',faces);

end

