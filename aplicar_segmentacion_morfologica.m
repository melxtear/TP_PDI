function [BW_limpia] = aplicar_segmentacion_morfologica(image)

    BW = edge(image, 'Canny');
   
    % Limpieza
    BW_rellena = imfill(BW, 'holes');
    BW_sin_borde = imclearborder(BW_rellena);
    
    se = strel('disk', 3);
    BW_separada = imerode(BW_sin_borde, se);
    
    % Filtro de área mínima, elimina ruido
    BW_limpia = bwareaopen(BW_separada, 3000); 
end