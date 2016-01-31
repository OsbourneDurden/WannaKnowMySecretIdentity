close all;
clear variables;

cam=webcam(1);
cam.Resolution=cam.AvailableResolutions{end};
str_res=cam.Resolution;
str_res(strfind(str_res,'x'))=' ';
dim_res=str2num(str_res);


hold on;
axis ij;
img=snapshot(cam);
image(img);
axis([0 dim_res(1) 0 dim_res(2)]);
nb_frames=100;
time=0;
cond=nb_frames;
while cond
    tic;
    img=snapshot(cam);
    %ici les choses à faire
    image(img);
    cond=cond-1;
    time=time+toc;
end

time_iter_loop=time/nb_frames
close(1);
clear cam cond str_res;