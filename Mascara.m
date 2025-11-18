function [MaskAorta, CentroideSiguiente] = Mascara(slice, CentroideAorta)
% MASCARA
% A partir de un slice 2D y un centroide previo de la aorta, esta función:
%   1) Ecualiza la imagen para mejorar contraste.
%   2) Obtiene un umbral local usando intensidades cercanas al centroide.
%   3) Genera una máscara binaria de la slice.
%   4) Aplica filtrado y limpieza morfológica.
%   5) Llama a PuntoInterno para extraer únicamente la región de la aorta.
%   6) Devuelve la nueva máscara y los centroides actualizados.
%
% Entradas:
%   slice          → imagen 2D
%   CentroideAorta → [x1 y1 x2 y2] centroide/s previa/s
%
% Salidas:
%   MaskAorta          → máscara final de la aorta
%   CentroideSiguiente → centroides actualizados

    %% Ecualización del histograma
    SEcualizada = histeq(slice, 256);

    %% Obtener intensidades cercanas al centroide actual
    R = 5;  % radio para muestreo local

    [rows, cols] = size(SEcualizada);
    [X, Y] = meshgrid(1:cols, 1:rows);

    % Máscara circular alrededor del centroide actual
    maskradio = (X - CentroideAorta(1)).^2 + (Y - CentroideAorta(2)).^2 <= R^2;

    % Obtener intensidades locales válidas
    valores = SEcualizada(maskradio);
    valores = valores(valores ~= 0 & ~isnan(valores));

    % Validación del umbral local
    if isempty(valores)
        error('No se pudo hallar un umbral local en la vecindad del centroide.');
    end

    min_val = min(valores);

    %% Generar máscara binaria usando el valor mínimo local
    Mask = SEcualizada >= min_val;

    %% Filtrado y limpieza morfológica
    Mask = medfilt2(Mask, [3 3]);  
    Mask = imopen(Mask, strel('disk', 2)); 

    %% Seleccionar la región de interés (aorta) con PuntoInterno
    % PuntoInterno también actualiza y retorna los centroides válidos
    [MaskAorta, CentroideSiguiente] = PuntoInterno(Mask, CentroideAorta);

    %% Visualización para control del tracking
    %
    figure(1)

    % Máscara intermedia (previa a PuntoInterno)
    subplot(1,2,1)
    imshow(Mask)
    hold on
    plot(CentroideAorta(1,1), CentroideAorta(1,2), 'r+', 'MarkerSize', 6, 'LineWidth', 1);
    plot(CentroideAorta(1,3), CentroideAorta(1,4), 'b+', 'MarkerSize', 6, 'LineWidth', 1);
    hold off

    % Máscara final extraída por PuntoInterno
    subplot(1,2,2)
    imshow(MaskAorta)
    hold on
    plot(CentroideAorta(1,1), CentroideAorta(1,2), 'r+', 'MarkerSize', 6, 'LineWidth', 1);
    plot(CentroideAorta(1,3), CentroideAorta(1,4), 'b+', 'MarkerSize', 6, 'LineWidth', 1);
    hold off

    impixelinfo
    pause(0.1)
    %}
end
