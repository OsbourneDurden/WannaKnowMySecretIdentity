function [GradGreylvl, imgShape, Ix, Iy] = edgeDetector (imgSrc)
% prend l'image NdG en paramètre, calcule le filtre passe haut vu en cours.
% Retourne le signal filtré selon x et y ainsi que l'image consituée des
% module des gradients.

greylvl = mean(imgSrc,3);

[Height, Width, ~] = size(imgSrc);

x = ones(15);
for i=1:15
    x(i,:) = (-7:7);
end
Teta = 1.6;

%% D?riv?e du filtre passe bas gaussien en x
dxFx = -x./(power(Teta,3)*sqrt(2*pi)) .* exp(-power(x,2)./(2*power(Teta,2)));

%% D?riv?e du filtre passe bas gaussien en y
dyFy = dxFx';

%% filtrage/convolution en X
Ix = conv2(double(dxFx), double(greylvl));  % passe haut 

%% filtrage/convolution en Y
Iy = conv2(double(dyFy), double(greylvl));  % passe haut

%% Extraction des contours avec le grad
GradGreylvl = sqrt(Ix.^2 + Iy.^2);  % mise en forme du gradient (module)


maxGrad = max(max(GradGreylvl,[],2)');      % valeur max du gradient (plus fort contour)
imgShape = (GradGreylvl>(maxGrad/10));      % Seuillage avec le dixieme du plus fort contour

GradGreylvl = GradGreylvl/maxGrad;

end
