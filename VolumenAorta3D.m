function [] = VolumenAorta3D(filename)

vol = nrrdread(filename);

VolMarcado = zeros([size(vol),3]); %RGB
[~, ~,numSlices] = size(vol);
CentroidesSlice = zeros(numSlices,2); %Vector de centroides de cada Slice formato [x,y]
CentroidesSlice(1,:) = CentroideInicial();

for i = size(vol,3):-1:1  
    [VolMarcado(:,:,i,:), CentroidesSlice(i+1,:)] = SegmentacionSlice(CentroidesSlice(i,:), vol(:,:,i));
end

volshow(VolMarcado);