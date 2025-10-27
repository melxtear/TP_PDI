function [Mask] = Segmentacion(image)
    %{
    FORMA LUCAS
    BW = edge(image, 'Canny');
   
    % Limpieza
    BW_rellena = imfill(BW, 'holes');
    BW_sin_borde = imclearborder(BW_rellena);
    
    se = strel('disk', 3);
    BW_separada = imerode(BW_sin_borde, se);
    
    % Filtro de área mínima, elimina ruido
    Mask = bwareaopen(BW_separada, 3000);
    %}

    % FORMA CON CIERRE MORFOLOGICO
    BWedge = edge(image, 'Canny');
    image_cerrada = imclose(BWedge,strel('disk',5));
    image_complemento = imcomplement(image_cerrada);
    Mask = image_complemento;

    %{ 
    FORMA CON IMFINDCIRCLES Y VISCIRCLES
    idx = -1;
    err = 10;
    BWedge = edge(image, 'Canny');
    figure(1)
    imshow(BWedge)
    
    [centros,radios] = imfindcircles(BWedge,[1 20]);
    
    for i = 1:size(centros,1)
        % calcular distancia euclídea al centroide
        dist = norm(centros(i,:) - centroideAorta);
        if dist < err
            idx = i;
        end
    end
    
    figure(2)
    imshow(image,[])
    viscircles([centros(idx,1),centros(idx,2)], radios(idx),'Color','b','LineWidth',1);
    %}
end