%vol = nrrdread("Dongyang\D1\D1.nrrd");

%{
for k = size(vol,3):-1:1
    imshow(vol(:,:,k));
    title(['Slice ' num2str(k)]);
    pause(0.05);
end
%}
%imshow(vol(:,:,190),[])
%impixelinfo
%VolumenAorta3D([315, 257],vol(:,:,100))
%VolumenAorta3D("Dongyang\D1\D1.nrrd")
%SegmentacionAorta3D([343, 273],vol(:,:,190))

for k = 100:200
    mask1 = Segmentacion(vol(:,:,k));
    %figure(1);
    %imshow(vol(:,:,k), []);
    figure(2);
    imshow(mask1);
end
