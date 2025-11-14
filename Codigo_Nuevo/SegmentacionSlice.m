function [SliceMarcada, CentroideSiguiente] = SegmentacionSlice(CentroideAorta, Slice)

[MaskAorta, CentroideSiguiente] = Mascara(Slice, CentroideAorta);

figure(1)

%SliceMarcada(:,:,1) = Slice(:,:,:).*int16(MaskAorta);
SliceMarcada(:,:,1) = MaskAorta;


end

