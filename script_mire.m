clear all;
close all;
addpath( genpath(pwd) );
figure('units','normalized','outerposition',[0 0 1 1]);

%cam = webcam(1);
%cam.Resolution = cam.AvailableResolutions{end};

g = 0;

while true
    %% Acquisition
    g=g+1;
    img =  imread(['rec/', num2str(g,'%05d'), '.png']);
    
    %img = snapshot(cam);
    
    
     %% Affichage de l'image source et son indice
    subplot(2,4,1);
    imshow(img);
    title(['image source #' num2str(g)]);
    
    
    %% Affichage et r�alisation des diff�rentes �tape de d�tection de la mire
    mireDetector(img);
    
end
