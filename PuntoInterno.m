function [MaskAorta, PuntoSiguiente] = PuntoInterno(mask, PuntoAorta)
% EXTRAERAORTA - Dado una máscara binaria y un punto dentro de la aorta,
% devuelve una nueva máscara con solo la región de la aorta.
%
% Entradas:
%   mask  : imagen binaria (fondo negro, regiones blancas)
%   punto : [fila, columna] de un punto dentro de la aorta
%
% Salida:
%   mask_aorta : máscara binaria con solo la región de la aorta

    % Verificamos que el punto esté dentro de la imagen
   %{
    [filas, cols] = size(mask);
    if PuntoAorta(1) < 1 || PuntoAorta(1) > filas || PuntoAorta(2) < 1 || PuntoAorta(2) > cols
        error('El punto está fuera de la imagen');
    end
   %}

    % Etiquetar las regiones blancas
    L = bwlabel(mask > 200);
    
    % Obtener la etiqueta del píxel donde está el punto
    etiqueta = L(PuntoAorta(2),PuntoAorta(1));
    
    if etiqueta == 0
        error('El punto no pertenece a ninguna región blanca.');
    end
    
    % Crear una nueva máscara con solo esa región
    MaskAorta = (L == etiqueta);
    PuntoSiguiente = PuntoAorta;
end