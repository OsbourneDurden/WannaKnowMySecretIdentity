v = VideoReader('../etc/test_new_mire.mp4');

i=1;
while i < v.Duration
    v.CurrentTime = i;
    filename = ['img' num2str(i) '.jpg']; 
    imwrite(readFrame(v),filename,'jpg');
    i = i + 1;
end