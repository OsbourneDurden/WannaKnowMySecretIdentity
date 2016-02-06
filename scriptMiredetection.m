clear variables;
close all

cam = webcam(1)
while true
    img = snapshot(cam);
    imshow(cornerDetector(img));
end
%imshow(cornerDetector(imread('img/domino.jpg')));