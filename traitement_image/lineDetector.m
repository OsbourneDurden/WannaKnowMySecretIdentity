function imgLines = lineDetector(imgShape)

[Height, Width] = size(imgShape);

dTeta = pi/180; % 1 degré de précision
dModule = 1; % 1 pixel de précision
maxModule = sqrt(power(Height,2) + power(Width,2));

HoughSpace = zeros(round(2*maxModule/dModule+1), round(2*pi/dTeta));

for x = 1:dModule:Height
    for y = 1:dModule:Width
        if(imgShape(x,y) == 1)
            for Teta = 0:dTeta:(2*pi-dTeta)
                Module = x*cos(Teta) + y*sin(Teta) + maxModule;                
                HoughSpace(round(Module/dModule)+1,round(Teta/dTeta)+1) = HoughSpace(round(Module/dModule)+1,round(Teta/dTeta)+1) +1;
            end
        end
    end
end


maxHough = max(max(HoughSpace,[],2)');
figure
imshow(HoughSpace./maxHough);
threshold = input('enter the threshold :');
if isempty(threshold)
    threshold = 0.55;
end
[modLines, tetaLines, ~] = find(HoughSpace >= maxHough*threshold);

modLines = ((modLines - 1) * dModule) - maxModule;
tetaLines = ((tetaLines -1) * dTeta);

imgLines = zeros(Height,Width);
for i = 1:length(modLines)    
    %imgLines(round(cos(tetaLines(i))*modLines(i))+1+3*Height, round(sin(tetaLines(i))*modLines(i))+1+3*Width) = 255;  
    if (tetaLines(i) ~= 0) || (tetaLines(i) ~= pi)
        for x = 0:Height
            y = round(-x/tan(tetaLines(i)) + modLines(i)/sin(tetaLines(i)));
            if y >= 0 && y < Width
                imgLines(x+1,y+1) = 255;
            end
        end
    else
        for y = 0:Width
            x = round(-y*tan(tetaLines(i)) + modLines(i)/cos(tetaLines(i)));
            if x >= 0 && x < Height
                imgLines(x+1,y+1) = 255;
            end
        end
    end
end
%imgLines = conv2(imgLines,ones(10));

end