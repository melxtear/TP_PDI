function [P, n, u, v] = BezierAorta(P0, P1, P2, Npts)
% BEZIERAORTA - Genera la curva de Bézier cuadrática del arco aórtico
% y los vectores locales para reconstrucción multiplanar.

    if nargin < 4
        Npts = 100;
    end

    % Vector de parámetros t
    t = linspace(0, 1, Npts)';

    % Curva de Bézier cuadrática
    P = (1-t).^2 * P0 + 2*(t.*(1-t)) * P1 + (t.^2) * P2;

    % Derivada y vector tangente
    dP = diff(P);
    n = dP ./ vecnorm(dP, 2, 2);
    n = [n; n(end,:)]; % misma longitud que P

    % Vector de referencia para construir el sistema local
    up = [0 0 1];
    if abs(dot(up, n(1,:))) > 0.9
        up = [0 1 0];
    end

    % Calcular los ejes ortogonales u y v (fila a fila)
    upMat = repmat(up, Npts, 1);
    u = cross(upMat, n, 2);
    u = u ./ vecnorm(u, 2, 2);
    v = cross(n, u, 2);
end
