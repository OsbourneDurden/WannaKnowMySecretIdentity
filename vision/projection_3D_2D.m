function [ P2D ] = projection_3D_2D( K, H )
%% Calcul d'une matrice de projection
%
% INPUT : [K, H] o� K est une matrice 3*3 de coordon�es intrins�ques d'une 
% cam�ra (ici diagonale sup�rieure), et H une matrice 3*3 d'homographie du 
% plan xOy vers un nouveau plan
% OUTPUT : [P2D], une matrice 4*3 de projection du syst�me dans le plan
% focal.
%
% Le pseudo-code de cette fonction � �t� donn� lors du cours de vision de
% Sio Hoi Ieng, c'est la deuxi�me question pos�e de la partie 2 : Mod�le
% g�om�trique d'une cam�ra

%% Donn�es du probl�me
P = K \ H; % mldivide
R1 = P(:,1);
R2 = P(:,2);
R3 = cross( R1, R2 ); % R3 = R1 ^ R2
alpha = det([ R1 R2 R3 ])^0.25; % Racine quatri�me

% Normalement, il faut tester alpha avec le P2D reconstruit, �tant donn�
% qu'il y a une ambiguit�. 
% Notre matrice K mise en entr�e est issue d'une d�composition rq, mais on
% a pris soin d'avoir en param�tres une distance focale correcte. Alpha
% doit donc �tre positif.

%% Reconstruction de la matrice de projection
P2D = K * [R1 R2 R3/alpha P(:,3)] / alpha; 
P2D = P2D / P2D(end,end);

end
