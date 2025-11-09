function [MaskAorta, CentroideSiguiente] = Mascara(slice, CentroideAorta)
    SEcualizada = histeq(slice,256);
    Mask = SEcualizada > 32000;
    
    %{
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

    Mask = imclose(Mask,strel('disk',1));

    [MaskAorta,CentroideSiguiente] = PuntoInterno(Mask, CentroideAorta);

    figure(1)
    subplot(1,2,1)
    imshow(Mask)
    subplot(1,2,2)
    imshow(MaskAorta)
    impixelinfo
    pause(0.025)
end
%% Comentarios a tener en cuenta
%PROBLEMA: en la primera imagen SI hay que marcar el centroide
%SOLUCION: dentro del objeto que encuentra que contiene al puntointerno, devolver el promedio de intensidades de
%ese objeto. FALTA APLICAR

%PROBLEMA: no detecta ambas ramas de la aorta
%SOLUCION: averiguar entre que slices estan las ramas de interes y hallar
%otra circunferencia similar a la actual. FALTA APLICAR

%PROBLEMA: no debe tomar vasos cercanos
%SOLUCION: que utilice conjuntos conexos pero de 4 pixeles, no 8. FALTA
%APLICAR