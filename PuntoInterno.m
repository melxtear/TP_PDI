function [MaskAorta, PuntosSiguiente] = PuntoInterno(mask, PuntosAorta)
% PUNTOINTERNO - Dada una máscara binaria y uno o más puntos dentro de la aorta,
% devuelve una nueva máscara con solo las regiones correspondientes a esos puntos.
% Además, detecta si aparecen nuevas regiones similares (ramas) y devuelve sus centroides.
%
% Entradas:
%   mask         : imagen binaria (fondo negro, regiones blancas)
%   PuntosAorta  : matriz Nx2 con los puntos [x, y] (máximo 2)
%
% Salidas:
%   MaskAorta       : máscara binaria con solo la(s) región(es) de la aorta
%   PuntosSiguiente  : coordenadas de los centroides de las regiones seleccionadas o similares

    % --- Validar puntos ---
    if size(PuntosAorta,2) ~= 4
        error('PuntosAorta debe tener formato Nx4 ([x, y])');
    end

    % --- Etiquetar regiones ---
    L = bwlabel(mask);  
    numLabels = max(L(:));
    if numLabels == 0
        error('No se detectaron regiones blancas en la máscara.');
    end

    % --- Obtener etiquetas de los puntos ---
    etiquetas = [];
    for k = 1:2:length(PuntosAorta)
        x = round(PuntosAorta(1,k));
        y = round(PuntosAorta(1,k+1));

        if y < 1 || y > size(L,1) || x < 1 || x > size(L,2)
            warning('El punto #%d está fuera de los límites de la imagen.', k);
            continue;
        end

        etiqueta = L(y, x);  % fila es Y, columna es X
        if etiqueta ~= 0
            etiquetas(end+1) = etiqueta; %#ok<AGROW>
        else
            warning('El punto #%d no pertenece a ninguna región blanca.', k);
        end
    end

    if isempty(etiquetas)
        error('Ninguno de los puntos pertenece a una región blanca.');
    end

    % --- Crear máscara de la aorta (región principal) ---
    MaskAorta = ismember(L, etiquetas);

    % --- Calcular centroides de la region seleccionada ---
    statsAorta = regionprops(MaskAorta, 'Centroid', 'Area','Eccentricity','Solidity');
    PuntosSiguiente = zeros(1,4);
    if all(PuntosAorta(:,3:4) ~= [0 0], 'all')
        %Calcular centroide de nueva region
        [~, idxMaxArea] = max([statsAorta.Area]);
        [~, idxMinArea] = min([statsAorta.Area]);
        PuntosSiguiente(1,3:4) = statsAorta(idxMaxArea).Centroid;
        PuntosSiguiente(1,1:2) = statsAorta(idxMinArea).Centroid;
    end

    if all(PuntosAorta(:,3:4) == [0 0], 'all') %Busqueda de la otra rama
        PuntosSiguiente(1,1:2) = statsAorta.Centroid;
        statsRegiones = regionprops(L, 'Area', 'Centroid','Eccentricity','Solidity');
        areas = [statsRegiones.Area];
        centroides = cat(1, statsRegiones.Centroid);
        eccentricidad = [statsRegiones.Eccentricity];
        solidez = [statsRegiones.Solidity];
        
        minArea = statsAorta.Area;
        tolEcc = statsAorta.Eccentricity;  % circularidad (0=círculo)
        tolSol = statsAorta.Solidity; % relleno (1=perfectamente relleno)

        idxFinal = find(eccentricidad < tolEcc & solidez > tolSol & areas > minArea); %Da vacio en algunos

        % Si se encontró una segunda región válida
        if numel(idxFinal) == 1
            etiquetas(end+1) = idxFinal; % agregar nueva etiqueta
            MaskAorta = ismember(L, etiquetas);
            statsFinal = regionprops(MaskAorta, 'Centroid');
            PuntosSiguiente(1,:) = [statsFinal(2).Centroid, statsFinal(1).Centroid];
            disp('>> Se encontró una segunda rama de la aorta.');

        elseif numel(idxFinal) > 1
            warning('Se encontraron múltiples regiones similares.');
            PuntosSiguiente(1,3:4) = [0 0];
        else
            warning('No encontro ninguna region similar.')
            PuntosSiguiente(1,3:4) = [0 0];
        end
    end

end
