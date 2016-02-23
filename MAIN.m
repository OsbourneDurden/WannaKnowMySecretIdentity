clear all;
close all;
figure;

cam = webcam(1);
cam.Resolution = cam.AvailableResolutions{end};
%g = 0;

while true
    %% Acquisition
    img = snapshot(cam);
    %g=g+1;
    %img =  imread(['rec/', num2str(g,'%05d'), '.png']);
    
    mireDetector(img);
    
end
