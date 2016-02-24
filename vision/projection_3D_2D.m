function [ P2D ] = projection_3D_2D( K, H )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

Pt = K\H;
Rt = zeros(3,4);
Rt(:,1) = Pt(:,1);% r1
Rt(:,2) = Pt(:,2);% r2
Rt(:,4) = Pt(:,3);% t
Rt(:,3) = cross(Rt(:,1),Rt(:,2));%r3 = r1 ^ r2
P2D = K * Rt;

end

