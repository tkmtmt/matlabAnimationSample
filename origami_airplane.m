function [verts,faces] = origami_airplane(scale)
%% �嗃
% ���W
p1 = [2/3 0 0];
p2 = [-1/3 1/2 0];
p3 = [-1/3 -1/2 0];
% �F
col1 = [1 0 0]; % [R,G,B]

%% ��������
% ���W
q1 = [2/3 0 0];
q2 = [-1/3 0 0];
q3 = [-1/3 0 1/4];
% �F
col2 = [0 0 1];


%% ����,�`��
verts = scale*[p1;p2;p3;q1;q2;q3];
faces = [1 2 3;
     4 5 6];
% col = [col1;col2];

% pat = patch('Faces',f,'Vertices',v,...
%     'FaceVertexCData',col,'FaceColor','flat','FaceAlpha',0.5);

%p = patch('Faces',f,'Vertices',v,'FaceColor','none','LineWidth',1); % wire flame
end