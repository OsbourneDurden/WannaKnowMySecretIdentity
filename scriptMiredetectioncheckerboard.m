clear variables;
close all;
addpath(genpath(pwd));

cam = webcam(1);
cam.Resolution=cam.AvailableResolutions{end};
figure;
h = imshow(snapshot(cam));
hold on;
p = [];
while true
    img = snapshot(cam);
    [points, s] = detectCheckerboardPoints(img);
    [a, MSGID] = lastwarn();
    warning('off', MSGID)

    
    
    
    
    delete(p);
    corners = zeros(2,4);
    if max(s) ~= 0
        
        corners(:,1) = points(1,:)';
        corners(:,2) = points(s(1)-1,:)';
        corners(:,3) = points(end-s(1)+2,:)';
        corners(:,4) = points(end,:)';
        imshow(img)
        plot(corners(1,1),corners(2,1),'or');
        plot(corners(1,2),corners(2,2),'og');
        plot(corners(1,3),corners(2,3),'ob');
        plot(corners(1,4),corners(2,4),'oy');
    end
    %set(h,'Cdata',img);
    %drawnow;
end