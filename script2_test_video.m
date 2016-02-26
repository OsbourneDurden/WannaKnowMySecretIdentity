close all;
clear variables;

%http://fr.mathworks.com/help/vision/examples/face-detection-and-tracking-using-the-klt-algorithm.html

addpath(genpath(pwd));
load('workspace.mat')
scale = 3;
f = figure('visible','on');
v = VideoReader('etc/test_mire_sd_better.mp4');
nb_Frames1 = floor(v.Duration*v.FrameRate);
video = readFrame(v);
video2 = imresize(video,1/scale);
h = imshow(video2);
hold on;
nb_fr = 1;
porsche = ply_to_patch('porsche.ply');
pt = patch('Faces',porsche.faces,'Vertices',porsche.vertex,'FaceColor','none','EdgeColor','none');
drawnow;
time=0;
cond = true;

while cond
    tstart = tic;
    t1 = toc(tstart);
    video = readFrame(v);
    t12 = toc(tstart);
    video2 = imresize(video,1/scale,'nearest');
    t13 = toc(tstart);
    [ pts_monde, points, s ] = detection_mire( video2 );
    t2 = toc(tstart);
    [a, MSGID] = lastwarn();

    if ~isempty(MSGID)
        warning('off', MSGID);
    end

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
    t7 = toc(tstart);
    t8 = toc(tstart);
    
    nb_fr = nb_fr + 1;
    time= time + toc(tstart);
    moyenne_fps = (nb_fr-1)/time;
    cond = hasFrame(v);
    disp([t1 t12 t13 t2 t3 t4 t5 t6 t7 t8]);
end