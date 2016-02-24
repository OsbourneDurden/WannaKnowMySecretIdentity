porsche = ply_to_patch('trophycup.ply', 0.1);
figure;
patch('Faces',porsche.faces,'Vertices',porsche.vertex,'FaceColor','none','EdgeColor','red');
axis equal;