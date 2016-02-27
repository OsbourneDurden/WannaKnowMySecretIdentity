%% Script d'extraction d'images jpg d'une vidéo.
% Ce script va prendre une photo toutes les secondes d'une video et va la
% ranger dans le dossier précisé dans img_folder.

img_folder = 'imgs';
video_filename = '/etc/test_mire_hd.mp4';


if( exist( img_folder, 'dir' ) == 0 ) 
    mkdir( img_folder );
end

v = VideoReader( video_filename );
i = 1;
while i < v.Duration
    v.CurrentTime = i;
    filename = [ img_folder '/img' num2str(i) '.jpg' ]; 
    imwrite( readFrame(v), filename, 'jpg' );
    i = i + 1;
end

clear v i filename;