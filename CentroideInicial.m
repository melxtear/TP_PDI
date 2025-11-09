function [x, y] = CentroideInicial(vol)
%Algoritmo de selección manual (se abre la imagen y permite seleccionar con
%un click)

imshow(vol(:,:,1), []);
impixelinfo
[x, y, ~] = ginput(1);

end