vol = nrrdread("Dongyang\D1\D1.nrrd");

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

%for k = 100:200
%    mask1 = SegmentacionSlice(vol(:,:,k));
    % mask1 = vol(:,:,k);
    % figure(1);
   %  imshow(vol(:,:,k), []);
  %   figure(2);
 %    imshow(mask1);
%end


[P0, P1, P2] = Marcar_Punto_Arco(vol);


[P, n, u, v] = Bezier_Aorta(P0, P1, P2);
vol_arco = Reconstruccion_MPR(vol, P, n, u, v);
figure;
isosurface(vol_arco, 50);
axis equal; view(3); camlight; lighting gouraud;
title('Reconstrucción 3D del arco aórtico');

figure; hold on; grid on; axis equal
plot3(P(:,1), P(:,2), P(:,3), 'r', 'LineWidth', 2)
plot3(P0(1), P0(2), P0(3), 'go', 'MarkerFaceColor','g')
plot3(P1(1), P1(2), P1(3), 'bo', 'MarkerFaceColor','b')
plot3(P2(1), P2(2), P2(3), 'ko', 'MarkerFaceColor','k')
quiver3(P(:,1), P(:,2), P(:,3), n(:,1), n(:,2), n(:,3), 10, 'b')
title('Curva Bézier y vectores tangentes del arco aórtico')
xlabel('X'); ylabel('Y'); zlabel('Z');
% for k = 160:200
 %     figure(1); 
  %    clf;
   %   imshow(vol(:,:,k), []);
   %   title(['Corte Z = ' num2str(k)]);
    %  pause(0.5);
   %end