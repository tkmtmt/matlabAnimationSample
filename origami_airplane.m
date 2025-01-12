function [verts,faces] = origami_airplane(scale)
%% 主翼
% 座標
p1 = [2/3 0 0];
p2 = [-1/3 1/2 0];
p3 = [-1/3 -1/2 0];
% 色
col1 = [1 0 0]; % [R,G,B]

%% 垂直尾翼
% 座標
q1 = [2/3 0 0];
q2 = [-1/3 0 0];
q3 = [-1/3 0 1/4];
% 色
col2 = [0 0 1];


%% 結合,描画
verts = scale*[p1;p2;p3;q1;q2;q3];
faces = [1 2 3;
     4 5 6];
% col = [col1;col2];

% pat = patch('Faces',f,'Vertices',v,...
%     'FaceVertexCData',col,'FaceColor','flat','FaceAlpha',0.5);

%p = patch('Faces',f,'Vertices',v,'FaceColor','none','LineWidth',1); % wire flame
end