close all;
clear variables;

addpath(genpath(pwd));
load('workspace.mat')

cam=webcam(1);
cam.Resolution=cam.AvailableResolutions{end};
str_res=cam.Resolution;

h = imshow(snapshot(cam));
hold on;
nb_fr = 1;

porsche = ply_to_patch('trophycup.ply', 0.1);
pt = patch('Faces',porsche.faces,'Vertices',porsche.vertex,'FaceColor','none','EdgeColor','none');
drawnow;
time = 0;
cond = true;
while cond
    tic;
    video = snapshot(cam);
    
    [ pts_monde, points, s ] = detection_mire( video );
    [a, MSGID] = lastwarn();
    if ~isempty(MSGID)
        warning('off', MSGID);
    end
    corners = zeros(2,4);
    if max(s) ~= 0
        H = calcul_matrice_homographie_dlt( pts_monde , points );
        P2 = projection_3D_2D( K, H );
        [ new_porsche_vertex ] = projection_points( porsche.vertex' , P2 );
        delete(pt);
        pt = patch('Faces',porsche.faces,'Vertices',new_porsche_vertex','FaceColor','none','EdgeColor','red');
    else
        delete(pt);
    end
    set(h,'Cdata',video);
    drawnow;

    nb_fr = nb_fr + 1;
    time= time + toc;
    cond = true;
end
nb_fps = (nb_fr-1)/time;