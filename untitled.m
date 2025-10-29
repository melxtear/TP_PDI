vol = nrrdread("Dongyang\D1\D1.nrrd");

%{
for k = size(vol,3):-1:1
    imshow(vol(:,:,k));
    title(['Slice ' num2str(k)]);
    pause(0.05);
end
%}
imshow(vol(:,:,190),[])
impixelinfo
SegmentacionAorta3D([315, 257],vol(:,:,100))