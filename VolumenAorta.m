function [] = VolumenAorta(filename, SliceInicial, SliceFinal)
% VOLUMENAORTA
% Dado un archivo .nrrd con un volumen 3D de un paciente, esta función:
%   1) Carga el volumen y recorta el rango de slices solicitado.
%   2) Permite seleccionar manualmente un centroide inicial.
%   3) Recorre slice por slice aplicando segmentación automática (Mascara).
%   4) Guarda los centroides actualizados para el tracking.
%   5) Calcula el coeficiente de Dice contra una segmentación de referencia.
%
% Entradas:
%   filename     → nombre base del archivo (sin .nrrd)
%   SliceInicial → primer slice a procesar
%   SliceFinal   → último slice a procesar
%
% Salidas:
%   Ninguna (imprime Dice y puede visualizar el volumen)

    %% Lectura del archivo original
    vol = nrrdread(filename + ".nrrd");

    % Recortar solo el rango de interés
    vol = vol(:,:,SliceInicial:SliceFinal,:);

    %% Inicialización de variables
    VolMarcado = zeros([size(vol), 1]);   % volumen segmentado final
    [~, ~, numSlices] = size(vol);

    % Matriz para guardar centroides en cada slice:
    %   [x1 y1 x2 y2]
    CentroidesSlice = zeros(numSlices, 4);

    %% Selección manual del centroide inicial
    % Centroides para el primer slice
    [x, y] = CentroideInicial(vol);
    CentroidesSlice(1,1) = x;
    CentroidesSlice(1,2) = y;


    %% Recorrido slice por slice
    for i = 1:numSlices

        % segmentación + actualización de centroides
        [VolMarcado(:,:,i), CentroidesSlice(i+1,:)] = Mascara(vol(:,:,i), CentroidesSlice(i,:));

    end

    %% Visualización volumétrica opcional
    %{
    volshow(VolMarcado, 'Colormap', [0 0 0; 1 0 0], 'IsosurfaceValue', 0.5);
    %}

    %% Cálculo del coeficiente de Dice
    % Cargar segmentación ground truth Dongyang
    VolDongyang = nrrdread(filename + ".seg.nrrd");

    % Recorte al mismo rango
    B = VolDongyang(:,:,SliceInicial:SliceFinal) > 0;
    A = VolMarcado > 0;

    % Cálculo del Dice
    inter = sum(A(:) & B(:));
    dice = 2 * inter / (sum(A(:)) + sum(B(:)));

    fprintf("Coeficiente de Dice: %.2f\n", dice);

end
