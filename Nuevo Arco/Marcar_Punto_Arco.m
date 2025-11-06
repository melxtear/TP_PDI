function [P1, P2, P3] = Marcar_Punto_Arco(vol)
  figure(1)
  imshow(vol(:,:,170), []);
  title('Seleccioná p0');
  [x1, y1] = ginput(1);

  figure(2)
  imshow(vol(:,:,170),[]);
  title('Seleccioná p2');
  [x2,y2] = ginput(1);

  figure(3);
  imshow(vol(:,:,199),[]);
  title('Seleccioná p1');
  [x3, y3] = ginput(1);
  
  disp([x1, y1]);
  disp([x2, y2]);
  disp([x3, y3]);
  P1 = [x1, y1, 170];
  P2 = [x3, y3, 199];
  P3 = [x2, y2, 170];
end 