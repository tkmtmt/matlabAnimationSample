function pat = propeller(R)
    N = 15;
    theta = linspace(0, 2*pi, N);
    X = R*cos(theta)';
    Y = R*sin(theta)';
    Z = zeros(size(X));
    V = [0,0,0;
         X,Y,Z];
    
    tmp = (2:N+1)';
    F = [ones(N, 1), tmp, circshift(tmp, -1)];  % 面の定義
    
    % １つ目のパッチだけ赤に
    % RGB 値からなる n×1×3 の配列
    col = repmat([0, 1, 0], N,1);   % 緑
    col(1,:) = [1, 0 0];    % 赤
    
    pat = patch('Faces', F, 'Vertices', V, ...
                 'FaceVertexCData', col, ...
                 'FaceColor', 'flat', ...
                 'FaceAlpha', .3);
end