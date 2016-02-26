function [ P2D ] = projection_3D_2D( K, H )
%% 

%% Donn�es du probl�me
PT = K\H; % mldivide
R1 = PT(:,1);
R2 = PT(:,2);
R3 = cross(R1,R2); % R3 = R1 ^ R2
alpha = det([R1 R2 R3])^0.25; % Racine quatri�me

%% Reconstruction de la matrice de projection
P2D = K*[R1 R2 R3/alpha PT(:,3)]/alpha; 
P2D = P2D/P2D(end,end);

end