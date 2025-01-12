function pat = stlA1200(scale)
    [V,F,N,name] = stlReadAscii('A1200.stl');
    vx = V(:,1);            % x���W
    s = max(vx)-min(vx);    % �S������
    V = 1/s*V;              % �S���Ő��K��
    V(:,1) = V(:,1) - 0.4;  % ���_���d�S�ɂ��炷
    V(:,1) = -V(:,1); %x���W���]   
    V(:,3) = -V(:,3); %z���W���]
%     V = (angle2dcm(0,0,0)'*OrigVerts')';    % �i�s����180����]
    V = scale*V;
    col = [0.5 0.5 0.5];
    pat = patch('Faces',F,'Vertices',V,'EdgeColor','none','FaceColor',col,'FaceAlpha',0.5);
    material('metal')
end