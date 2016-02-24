function [ points_plan_xoy, points_image, s ] = detection_mire( img )

[points, s] = detectCheckerboardPoints(img);
if max(s) ~= 0
    points_plan_xoy = vertcat(repmat(1:s(1)-1,1,s(2)-1), ...
        reshape(repmat(1:s(2)-1,s(1)-1,1),1,prod(s-1)));

    points_image = points';
else
    points_plan_xoy = [];
    points_image = [];
end

