function vol_arco = Reconstruccion_MPR(vol, P, n, u, v)
    vol = double(vol); % asegurar tipo válido

    % Parámetros de tamaño del corte
    ancho = 30;
    paso = 1;
    [X, Y] = meshgrid(-ancho:paso:ancho, -ancho:paso:ancho);
    Z = zeros(size(X));

    % Inicializar volumen resultante
    num_cortes = length(P);
    vol_arco = zeros(size(X,1), size(X,2), num_cortes);

    for i = 1:num_cortes
        center = P(i, :);
        Ri = [u(i,:); v(i,:); n(i,:)];

        local_pts = [X(:), Y(:), Z(:)]';
        global_pts = Ri' * local_pts + center';

        valores = interp3(vol, global_pts(1,:), global_pts(2,:), global_pts(3,:), 'linear', 0);
        plano = reshape(valores, size(X));

        vol_arco(:,:,i) = plano; % guardo el corte
    end

    % Mostrar una vista rápida
    figure;
    montage(uint8(vol_arco), 'DisplayRange', []);
    title('Cortes oblicuos unidos del arco aórtico');
end
