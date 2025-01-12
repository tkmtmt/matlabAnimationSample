function pat = A1200(scale)
    fileName = "A1200.stl";
    TR = stlread(fileName);
    V = TR.Points;
    F = TR.ConnectivityList;

    % 正規化
    vx = V(:,1);    % x座標
    L = max(vx) - min(vx);
    V = V/L;    % 全長を1に
    
    % 座標系
    V(:,1) = -V(:,1);   % x軸反転
    V(:,3) = -V(:,3);   % z軸反転
    
    % オフセット
    V(:,1) = V(:,1) + 0.4;

    % スケール
    V = scale*V;

    % pat = patch('Faces',F,'Vertices',V,"FaceColor",'none');
    pat = patch('Faces',F,'Vertices',V,'EdgeColor','none',"FaceColor",0.5*[1 1 1],'FaceAlpha',1);
end