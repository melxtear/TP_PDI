function [MaskAorta, CentroideSiguiente] = CentroideMasCercano(Mask, CentroideAorta)
    
    stats = regionprops(Mask, 'Centroid', 'Solidity', 'Area', 'Eccentricity', 'PixelIdxList');

    if isempty(stats)
        MaskAorta = false(size(BW));
        CentroideSiguiente = [0, 0];
        return
    end

    % Extraer propiedades como vectores
    centros = cat(1, stats.Centroid);
    sol = [stats.Solidity];
    area = [stats.Area];
    ecc = [stats.Eccentricity];

    % --- Filtros previos para descartar ruido y fondo ---
    validas = sol > 0.8 & ecc < 0.85 & area < prctile(area, 90) & area > 50;
    stats = stats(validas);
    centros = centros(validas,:);
    sol = sol(validas);

    % Si después de filtrar no queda nada:
    if isempty(stats)
        MaskAorta = false(size(BW));
        CentroideSiguiente = [0, 0];
        return
    end

    % Calcular distancia entre centroides
    dist = vecnorm(centros - CentroideAorta, 2, 2);

    % Normalizar ambas métricas (para compararlas en la misma escala)
    dist = dist / max(dist);
    sol = sol / max(sol);

    score = (1 - sol) + dist; 

    % Elegir la región con mejor puntaje (mínimo score)
    [~, idx] = min(score);

    % Crear máscara final
    MaskAorta = false(size(Mask));
    MaskAorta(stats(idx).PixelIdxList) = true;

    % Guardar nuevo centroide
    CentroideSiguiente = stats(idx).Centroid;
end
