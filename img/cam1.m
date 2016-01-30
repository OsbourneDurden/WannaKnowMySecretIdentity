%-- Focal length:
fc = [ 6611.032072; 6610.967963 ];

%-- Principal point:
cc = [ 964.687952; 983.651464 ];
%-- Skew coefficient:
alpha_c = 0.000166;

%-- Distortion coefficients:
kc = [-0.175989; 0.298818; -0.000545; 0.000033; 0.000000];


% Extrinsic parameters:
%-- Image #8:
omc_8 = [ 1.411769 ; 1.779961 ; -1.032585 ];
Tc_8 = [ -330.591200 ; -190.959100 ; 3255.490000 ];

%-- 3x4 projection matrix
proj_8 = [ -2293.26 6261.17 -418.36 954773; 2314.1 583.138 -6243.18 1.93984e+06; -0.850415 -0.190181 -0.490535 3255.49];