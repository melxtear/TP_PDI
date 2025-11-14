vol = nrrdread("Dongyang\D6\D6.nrrd");

for k = 1:size(vol,3)
    imshow(vol(:,:,k),[])
    hold on
    title(sprintf('Slice %d', k));

    pause(0.2)
end