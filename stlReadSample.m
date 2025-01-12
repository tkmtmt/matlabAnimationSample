clear
close all
clc

TR = stlread('A1200.stl');
V = TR.Points;
F = TR.ConnectivityList;

%% 座標系の修正とサイズの正規化
% 正規化
vx = V(:,1);    % x座標
L = max(vx) - min(vx);
V = V/L;    % 全長を1に

% 座標系
V(:,1) = -V(:,1);   % x軸反転
V(:,3) = -V(:,3);   % z軸反転

% オフセット
V(:,1) = V(:,1) + 0.4;

%% 
figure;
% pat = patch('Faces',F,'Vertices',V,'FaceColor','none');
pat = patch('Faces',F,'Vertices',V,'EdgeColor','none',"FaceColor",0.5*[1 1 1]);

axis equal
grid on
ax = gca;
ax.XDir = 'reverse';
ax.ZDir = 'reverse';
view(3)
xlabel('x');
ylabel('y');
zlabel('z');
view(3)

lighting gouraud
light(ax,"Position",[0,0,-1]);

