function [MaskAorta, CentroidesSiguiente] = PuntoInterno(Mask, CentroidesAorta)
% PUNTOINTERNO
% Dada una máscara binaria y uno o dos puntos pertenecientes a la aorta,
% esta función:
%   1) Identifica qué región binaria contiene esos puntos.
%   2) Devuelve una máscara reducida solo a esas regiones.
%   3) Calcula los nuevos centroides.
%   4) Busca automáticamente si aparece una segunda rama (similar en
%      morfología a la principal) y la devuelve como segundo centroide.
%
% Entradas:
%   Mask         : imagen binaria (0/1)
%   CentroidesAorta  : [x1 y1 x2 y2], el primer punto y un segundo punto opcional
%
% Salidas:
%   MaskAorta        : máscara que contiene solo las regiones asociadas a esos puntos
%   CentroidesSiguiente   : [x1 y1 x2 y2] centroides actualizados


    %% Validación de entrada
    if size(CentroidesAorta,2) ~= 4
        error('PuntosAorta debe tener formato [x1 y1 x2 y2].');
    end


    %% Etiquetar todas las regiones encontradas
    L = bwlabel(Mask, 4);     % Conectividad 4
    numLabels = max(L(:));

    if numLabels == 0
        error('No se detectaron regiones blancas en la máscara.');
    end


    %% Obtener la etiqueta correspondiente a cada punto
    etiquetas = [];

    for k = 1:2:length(CentroidesAorta)
        x = round(CentroidesAorta(1, k));
        y = round(CentroidesAorta(1, k+1));

        % Checkear límites
        if y < 1 || y > size(L,1) || x < 1 || x > size(L,2)
            warning('El punto #%d está fuera de los límites de la imagen.', k);
            continue;
        end

        etiqueta = L(y, x);

        if etiqueta ~= 0
            etiquetas(end+1) = etiqueta; 
        else
            warning('El punto #%d no pertenece a ninguna región blanca.', k);
            % Se borra el punto si no está en ninguna región
            CentroidesAorta(1,k:k+1) = [0 0];
        end
    end

    if isempty(etiquetas)
        error('Ninguno de los puntos pertenece a una región blanca.');
    end


    %% Crear máscara solo de las regiones seleccionadas
    MaskAorta = ismember(L, etiquetas);


    %% Propiedades de la región actual
    statsAorta = regionprops(MaskAorta, 'Centroid', 'Area', 'Eccentricity', 'Solidity');

    % Inicialización de salida
    CentroidesSiguiente = zeros(1,4);


    %% Caso 1: Ya existen dos puntos → solo actualizar centroides
    if all(CentroidesAorta(:,3:4) ~= [0 0], 'all')

        % Se asume que hay dos regiones: buscar la más grande y la más chica
        [~, idxMaxArea] = max([statsAorta.Area]);
        [~, idxMinArea] = min([statsAorta.Area]);

        CentroidesSiguiente(1,3:4) = statsAorta(idxMaxArea).Centroid;
        CentroidesSiguiente(1,1:2) = statsAorta(idxMinArea).Centroid;

        return
    end


    %% Caso 2: Solo hay un punto → buscar la segunda rama
    % Guardar el centroide de la región inicial
    CentroidesSiguiente(1,1:2) = statsAorta.Centroid;

    % Analizar TODAS las regiones etiquetadas del slice
    statsRegiones = regionprops(L, 'Area', 'Centroid', 'Eccentricity', 'Solidity');
    areas = [statsRegiones.Area];
    centroides = cat(1, statsRegiones.Centroid);
    eccentricidad = [statsRegiones.Eccentricity];
    solidez = [statsRegiones.Solidity];

    % Parámetros de tolerancia para detectar una región "similar"
    minArea = statsAorta.Area;
    tolEcc = 0.6;                                % morfología poco elongada
    tolSol = statsAorta.Solidity - 0.02;         % tan sólida como la original

    % Buscar regiones comparables
    idxFinal = find(eccentricidad < tolEcc & solidez > tolSol & areas > minArea);

    % Si aparece solo una región candidata:
    if numel(idxFinal) == 1
        etiquetas(end+1) = idxFinal;               % agregar etiqueta
        MaskAorta = ismember(L, etiquetas);        % máscara final combinada

        statsFinal = regionprops(MaskAorta, 'Centroid');
        % Ordenar: se asume que statsFinal(1) ← principal, statsFinal(2) ← nueva
        CentroidesSiguiente(1,:) = [statsFinal(2).Centroid, statsFinal(1).Centroid];

        disp('>> Se encontró una segunda rama de la aorta.');
        return
    end

    % Si aparecen múltiples:
    if numel(idxFinal) > 1
        warning('Se encontraron múltiples regiones similares.');
        CentroidesSiguiente(1,3:4) = [0 0];
        return
    end

    % Si no aparece ninguna
    warning('No se encontró ninguna región similar.');
    CentroidesSiguiente(1,3:4) = [0 0];

end
