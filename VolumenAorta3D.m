function [] = VolumenAorta3D(filename, SliceInicial, SliceFinal)

vol = nrrdread(filename);
vol = vol(:,:,SliceInicial:SliceFinal,:);
VolMarcado = zeros([size(vol),1]); %RGB
[~, ~,numSlices] = size(vol);
CentroidesSlice = zeros(numSlices,4); %Vector de centroides de cada Slice formato [x,y]
[x,y] = CentroideInicial(vol);
CentroidesSlice(1,1) = x;
CentroidesSlice(1,2) = y;

for i = 1:size(vol,3)  
    [VolMarcado(:,:,i), CentroidesSlice(i+1,:)] = SegmentacionSlice(CentroidesSlice(i,:), vol(:,:,i));
end

%volshow(VolMarcado);
%volshow(VolMarcado, 'Colormap', [0 0 0; 1 0 0],'IsosurfaceValue',0.5);
