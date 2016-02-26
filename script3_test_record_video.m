close all;
clear variables;

addpath(genpath(pwd));
load('workspace.mat')
scale = 1;
f = figure('visible','off');
v = VideoReader('etc/test_mire_sd_better.mp4');
nb_Frames1 = floor(v.Duration*v.FrameRate);
v2 = VideoWriter('rendu2.mp4','MPEG-4');
v2.FrameRate = v.FrameRate;
open(v2);
h = imshow(imresize(readFrame(v),1/scale));
hold on;
nb_fr = 1;

porsche = ply_to_patch('porsche.ply', 0.1);
pt = patch('Faces',porsche.faces,'Vertices',porsche.vertex,'FaceColor','none','EdgeColor','none');
drawnow;
time=0;
cond = true;
bar = waitbar(0,'Creation de la video...');
while cond
    tstart = tic;
    video = readFrame(v);
    waitbar(nb_fr / nb_Frames1)
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
      
        maxs = max(porsche.vertex);
        new_porsche_vertex = porsche.vertex./maxs(1).*(s(1)+2)./2;
        new_porsche_vertex = [new_porsche_vertex(:,2) ...
            new_porsche_vertex(:,1) new_porsche_vertex(:,3)];
        new_porsche_vertex(:,1) = new_porsche_vertex(:,1)+s(1)./2;
        new_porsche_vertex(:,2) = new_porsche_vertex(:,2)+s(2)./2;
        
        [ new_porsche_vertex ] = projection_points( new_porsche_vertex' , P2 );
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
    F=getframe(gca);
    t7 = toc(tstart);
    writeVideo(v2,F.cdata);
    t8 = toc(tstart);
    
    nb_fr = nb_fr + 1;
    time= time + toc(tstart);
    moyenne_fps = (nb_fr-1)/time;
    cond = hasFrame(v);
    disp([t1 t2 t3 t4 t5 t6 t7 t8]);
end
close(v2);
close(bar);