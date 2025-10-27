function [SliceMarcada, CentroideSiguiente] = SegmentacionSlice(CentroideAorta, Slice)

Mask = Segmentacion(Slice);

[MaskAorta,CentroideSiguiente] = CentroideMasCercano(Mask, CentroideAorta);

SliceMarcada(:,:,1) = Slice(:,:,:).*int16(MaskAorta);

figure(1)
imshow(MaskAorta)
pause(0.05)
end

