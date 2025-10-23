function [mask] = SegmentacionAorta3D(centroideAorta, image)
if centroideAorta == [0, 0]
    %Es la primera imagen
    centroideAorta = seleccionarManual();
end
%{
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

% OTRA FORMA

BWedge = edge(image, 'Canny');
figure(1)
imshow(BWedge)

image_erosionada = imclose(BWedge,strel('disk',8));
figure(4)
imshow(image_erosionada)

img_cerrada = imcomplement(image_erosionada);
figure(5)
imshow(img_cerrada)

image_rellenada = imfill(img_cerrada,"holes");
figure(2)
imshow(image_rellenada)

stats = regionprops(img_cerrada, 'Centroid', 'PixelIdxList');

% Calcular distancias al centroide dado
distancias = arrayfun(@(s) norm(s.Centroid - centroideAorta), stats);

% Buscar la región más cercana
[~, idx] = min(distancias);

% Crear máscara de esa región
BWmask = false(size(image_erosionada));
BWmask(stats(idx).PixelIdxList) = 1;

figure(3)
imshow(image,[])
hold on;
h = imshow(cat(3, zeros(size(BWmask)), zeros(size(BWmask)), ones(size(BWmask))));
set(h, 'AlphaData', 0.2 * BWmask);

