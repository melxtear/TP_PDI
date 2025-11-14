function [MaskAorta, CentroideSiguiente] = Mascara(slice, CentroideAorta)
    SEcualizada = histeq(slice,256);
    %SEcualizada = histeq(mat2gray(slice),256);
    %Mask = SEcualizada > 32000;
   
    R = 5;

    [rows, cols] = size(SEcualizada);
    [X, Y] = meshgrid(1:cols, 1:rows);
    maskradio = (X - CentroideAorta(1)).^2 + (Y - CentroideAorta(2)).^2 <= R^2;
    valores = SEcualizada(maskradio);
    valores = valores(valores ~= 0 & ~isnan(valores));

    if isempty(valores)
       error('No se pudo hallar un umbral');
    else
        min_val = min(valores);
    end
    Mask = SEcualizada >= min_val;
    %Version automatizada
    %}
    
    Mask = medfilt2(Mask, [3 3]);
    Mask = imopen(Mask,strel('disk',1));
    %Mask = imfill(Mask, "holes");

    [MaskAorta,CentroideSiguiente] = PuntoInterno(Mask, CentroideAorta);

    
    
    figure(1)
    subplot(1,2,1)
    imshow(Mask)
    subplot(1,2,2)
    imshow(MaskAorta)
    impixelinfo
    pause(0.1)
    %}
end
%% Comentarios a tener en cuenta
%PROBLEMA: en la primera imagen SI hay que marcar el centroide
%SOLUCION: dentro del objeto que encuentra que contiene al puntointerno, devolver el promedio de intensidades de
%ese objeto. FALTA APLICAR

% D6 funciona bien con imopen + imfill, porque la 2da rama en algunas
% slices desaparece por ser tan granulada.
%Pero D4 le pones eso y anda mal. sale bien con el imopen pero agregandole
%el imfill no.
%Ideas: que por cada punto centroide, haga un promedio de las intensidades
%--> Convendria combinar mascara y punto interno. 