clear variables;
close all;

addpath(genpath(pwd));
load('workspace.mat')
porsche = plyread('big_porsche.ply');
porsche_vertex = [porsche.vertex.z+4 porsche.vertex.x+4 porsche.vertex.y];
porsche_faces = zeros(length(porsche.face.vertex_indices),3);
for i=1:length(porsche.face.vertex_indices)
    porsche_faces(i,:)=porsche.face.vertex_indices{i};
end

porsche_vertex =  porsche_vertex ./8;
porsche_faces = porsche_faces+1;

figure;
cam = webcam(1);
cam.Resolution=cam.AvailableResolutions{end};
h=imshow(snapshot(cam));
pt = patch('Faces',porsche_faces,'Vertices',porsche_vertex,'FaceColor','none','EdgeColor','none');

while true
    tstart = tic;
    img=snapshot(cam);
    t1=toc(tstart);
    
    
    t2=toc(tstart);
    [points, s] = detectCheckerboardPoints(img);
    [a, MSGID] = lastwarn();
    if ~isempty(MSGID)
        warning('off', MSGID);
    end
    t3=toc(tstart);
    corners = zeros(2,4);
    if max(s) ~= 0
        corners(:,1) = points(1,:)';
        corners(:,2) = points(s(1)-1,:)';
        corners(:,3) = points(end-s(1)+2,:)';
        corners(:,4) = points(end,:)';
        pts_monde = [0 0; 0 1; 1 0; 1 1]';
        
        [ H ] = calcul_matrice_homographie_dlt( pts_monde , corners );
        
        Pt = K\H;
        Rt = zeros(3,4);
        Rt(:,1) = Pt(:,1);% r1
        Rt(:,2) = Pt(:,2);% r2
        Rt(:,4) = Pt(:,3);% t
        Rt(:,3) = cross(Rt(:,1),Rt(:,2));%r3 = r1 ^ r2
        P2 = K * Rt;
        
        [ new_porsche_vertex ] = projection_points( porsche_vertex' , P2 );
        delete(pt);
        pt = patch('Faces',porsche_faces,'Vertices',new_porsche_vertex','FaceColor','none','EdgeColor','red');
    else
        delete(pt);
    end
    set(h,'Cdata',img);
    drawnow;
    t4=toc(tstart);
    disp([t1 t2 t3 ceil(1/t4)]);
end