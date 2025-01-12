function pat = stlA1200(scale)
    [V,F,N,name] = stlReadAscii('A1200.stl');
    vx = V(:,1);            % x座標
    s = max(vx)-min(vx);    % 全長測定
    V = 1/s*V;              % 全長で正規化
    V(:,1) = V(:,1) - 0.4;  % 原点を重心にずらす
    V(:,1) = -V(:,1); %x座標反転   
    V(:,3) = -V(:,3); %z座標反転
%     V = (angle2dcm(0,0,0)'*OrigVerts')';    % 進行方向180°回転
    V = scale*V;
    col = [0.5 0.5 0.5];
    pat = patch('Faces',F,'Vertices',V,'EdgeColor','none','FaceColor',col,'FaceAlpha',0.5);
    material('metal')
end