function [ fc, cc, alpha_c ] = composantes_parametres_intrinseques( K )
%% Composantes de la matrice intrinsèque
%
% INPUT : K matrice triangulaire supérieure 3*3
% OUTPUT : fc et cc points (2*1) correspondant à la distance focale et le
% point principal, et alpha_c scalaire correspondant au coefficient de
% biais du pixel

%-- Focal length:
fc = [ K(1); K(5) ];
%-- Principal point:
cc = [ K(7); K(8) ];
%-- Skew coefficient:
alpha_c = K(4)/K(5);
% Sauf que c'est pas K(4)=skew=f_y*tan alpha? Informations contradictoires

end