close all;
clear variables;

addpath(genpath(pwd));
load('workspace.mat')
scale = 1;
v = VideoReader('etc/test_mire_sd.mp4');
h = imshow(imresize(readFrame(v),1/scale));
hold on;
nb_fr = 1;

porsche = ply_to_patch('trophycup.ply', 0.1);
pt = patch('Faces',porsche.faces,'Vertices',porsche.vertex,'FaceColor','none','EdgeColor','none');
drawnow;
time=0;
cond = true;

while cond
    tstart = tic;
    video = readFrame(v);
    t1 = toc(tstart);
    video2 = imresize(video,1/scale);
    [ pts_monde, points, s ] = detection_mire( video2 );
    t2 = toc(tstart);
    [a, MSGID] = lastwarn();
    if ~isempty(MSGID)
        warning('off', MSGID);
    end
    corners = zeros(2,4);
    t3=0;t4=0;t5=0;
    if max(s) ~= 0
        H = calcul_matrice_homographie_dlt( pts_monde , points );
        t3 = toc(tstart);
        P2 = projection_3D_2D( K, H );
        [ new_porsche_vertex ] = projection_points( porsche.vertex' , P2 );
        t4 = toc(tstart);
        delete(pt);
        pt = patch('Faces',porsche.faces,'Vertices',new_porsche_vertex','FaceColor','none','EdgeColor','red');
        t5 = toc(tstart);
    else
        delete(pt);
    end
    set(h,'Cdata',video2);
    drawnow;
    t6 = toc(tstart);
    %disp([t1 t2 t3 t4 t5 t6]);
    nb_fr = nb_fr + 1;
    time= time + toc;
    nb_fps = 1/toc(tstart);
    cond = hasFrame(v);
end
nb_fps = (nb_fr-1)/time;