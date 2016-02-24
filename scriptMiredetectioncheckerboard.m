clear variables;
close all;
addpath(genpath(pwd));

cam = webcam(1);
cam.Resolution=cam.AvailableResolutions{end};
figure;
imshow(snapshot(cam));
hold on;

while true
    img = snapshot(cam);
    imshow(img);
    [points, s] = detectCheckerboardPoints(img);
    
    [a, MSGID] = lastwarn();
    warning('off', MSGID)
    
    corners = zeros(4,2);
    if max(s) ~= 0
        corners(1,:) = points(1,:);
        corners(2,:) = points(s(1)-1,:);
        corners(3,:) = points(end-s(1)+2,:);
        corners(4,:) = points(end,:);
        plot(corners(:,1),corners(:,2),'or');
    end
end