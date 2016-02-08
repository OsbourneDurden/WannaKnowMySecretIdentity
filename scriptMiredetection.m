clear variables;
close all;

cam = webcam(1);
figure;

while true
    img = snapshot(cam);
    img = img(1:2:720,1:2:1280,:);
    %img =  imread('img/mire.png');
    imshow(img);
    
    %corners = cornerDetector(img);
    corners = corner(mean(img,3),20);
    hold on;
    plot(corners(:,1),corners(:,2),'b+');
    
    [Height, Width, ~] = size(img);
    mire = [];
    mask = 1;
    for i = 1:size(corners(:,1))
        if (corners(i,1) > mask) && (corners(i,2) > mask) && (corners(i,1) < (Width-mask)) && (corners(i,2) < (Height-mask))
            %moyLocalRGB     = mean2(img(corners(i,1)-5:corners(i,1)+5, corners(i,2)-5:corners(i,2)+5, :));
            moyLocalRed     = round(mean2(img(corners(i,2)-mask:corners(i,2)+mask, corners(i,1)-mask:corners(i,1)+mask, 1)));
            moyLocalGreen   = round(mean2(img(corners(i,2)-mask:corners(i,2)+mask, corners(i,1)-mask:corners(i,1)+mask, 2)));
            moyLocalBlue    = round(mean2(img(corners(i,2)-mask:corners(i,2)+mask, corners(i,1)-mask:corners(i,1)+mask, 3)));
            moyLocalRGB     = round((moyLocalBlue + moyLocalGreen + moyLocalRed)/3);
            
%             if (moyLocalBlue > (0.95*moyLocalRGB)) && (moyLocalRed < (1.05*moyLocalRGB)) && (moyLocalGreen < (1.05*moyLocalRGB))
%             	mire = [mire ; corners(i,:)];
%             end 
            if (moyLocalRed > (moyLocalBlue)) && (moyLocalRed > (moyLocalGreen))
            	mire = [mire ; corners(i,:)];
            end 
        end
    end
    
    %% Extraire les 4 premiers points mire possible
    [selec, ~] = size(mire);
    if (isempty(mire)==0) && (selec > 4)
        j = 0;
        k = 1;
        while (k < selec)
            j = j + 1;
            if j == selec
                j = 1;
            end
            if mean2(img(mire(j,2)-mask:mire(j,2)+mask,mire(j,1)-mask:mire(j,1)+mask,1)) < mean2(img(mire(j+1,2)-mask:mire(j+1,2)+mask,mire(j+1,1)-mask:mire(j+1,1)+mask,1))
                tmp = mire(j+1, :);
                mire(j+1, :) = mire(j, :);
                mire(j, :) = tmp;

                k = 1;
            else
                 k = k + 1;
            end       
        end  
        mire = mire(1:4,:);  
    end
    
    if isempty(mire) == 0
        hold on;
        plot(mire(:,1),mire(:,2),'r+');
    end
    
    

    
            
    %hold on;
    %plot(mire(:,1),mire(:,2),'g+');


end
%imshow(cornerDetector(imread('img/domino.jpg')));