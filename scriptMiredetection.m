clear variables;
close all

cam = webcam(1)

while true
    img = snapshot(cam);
    corners = cornerDetector(img)*255;
    corners = conv2(ones(5)*255,corners);
    img(:,:,1) = double(img(:,:,1))+double(corners(3:722,3:1282));
    
    imshow(img);
end
%imshow(cornerDetector(imread('img/domino.jpg')));