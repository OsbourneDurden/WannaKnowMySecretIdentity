close all;
clear variables;
tic;
addpath(genpath(pwd));
load('workspace.mat')

v = VideoReader('etc/test_mire_sd_better.mp4');
v.CurrentTime = 36;
h = imshow(readFrame(v));
hold on;
nb_fr = 1;
time=0;

porsche = ply_to_patch('porsche.ply', 0.1);
pt = patch('Faces',porsche.faces,'Vertices',porsche.vertex,'FaceColor','none','EdgeColor','none');
drawnow;

cond = true;
toc
while cond
    tic;
    video = readFrame(v);
    
    [ pts_monde, points, s ] = detection_mire( video );
    [a, MSGID] = lastwarn();
    if ~isempty(MSGID)
        warning('off', MSGID);
    end
    corners = zeros(2,4);
    if max(s) ~= 0
        H = calcul_matrice_homographie_dlt( pts_monde , points );
        P2 = projection_3D_2D( K, H );
        
        %temporaire, pour tester Z
        altitude_pts_monde = 0;
        points_monde_2 = vertcat(repmat(0:s(1),1,s(2)+1), ...
        reshape(repmat(0:s(2),s(1)+1,1),1,prod(s+1)), ...
        altitude_pts_monde*ones(1,prod(s+1)));
        [ new_points_monde ] = projection_points( points_monde_2 , P2 );  
        delete(pt)
        pt = plot(new_points_monde(1,:),new_points_monde(2,:),'*r');
        
        %[ new_porsche_vertex ] = projection_points( porsche.vertex' , P2 );
        %delete(pt);
        %pt = patch('Faces',porsche.faces,'Vertices',new_porsche_vertex','FaceColor','none','EdgeColor','red');
    else
        delete(pt);
    end
    set(h,'Cdata',video);
    drawnow;

    nb_fr = nb_fr + 1;
    time= time + toc;
    cond = v.CurrentTime < 39;
end
nb_fps = (nb_fr-1)/time;