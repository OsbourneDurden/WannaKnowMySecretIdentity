function imgMire = mireDetector(imgCorner)
    %[h, l] = find(imgCorner > 0);
    h = imgCorner (:,1);
    l = imgCorner (:,2);

    imgMire = [];
        
    minC = 2.53;
    maxC = 2.5340;
    
    for i = 1:size(h)
        for j = 1:size(h)
            A = distance(h(i),l(i),h(j),l(j));
            for k = 1:size(h)
                B = distance(h(i),l(i),h(k),l(k));
                C = A/B;
                if ((C > minC) && (C < maxC))
                    D = distance(h(j),l(j),h(k),l(k));
                    if (abs(B - A) > (D * 0.999)) && (abs(B - A) < (D * 1.001))
                        imgMire(i,:) = imgCorner(i,:);
                        imgMire(k,:) = imgCorner(k,:);
                        %imshow(imgMire);
                        %return;
                    end
                end
            end
        end
    end
    
    %mire = sum(imgMire(:)==1)
end