% ２次元三角形パッチサンプル
clear
close all
clc

x = [0, -0.5, 0.5];
y = [2/3, -1/3, -1/3];

figure;
pat = patch(x, y, 'b', 'FaceAlpha',.3);
axis equal
grid on
xline(0);
yline(0);
xlim(1.5*[-1 1])
ylim(1.5*[-1 1])
xlabel("x");
ylabel("y");

%% 回転
theta = deg2rad(10);
Rz = [cos(theta), -sin(theta);
      sin(theta), cos(theta)];

u = pat.Vertices;
v = (Rz*u')';

pat.Vertices = v;

%% 頂点座標と連結頂点で一気に指定(頂点数は同じじゃないと行けない)
% vert = [x1, y1;
%         x2, y2;
%         x3, y3;
%         ...
%         xn, yn];

phi = linspace(0, 2*pi, 7);
x = cos(phi);
y = sin(phi);
u = [x',y'];
F = 1:6;
F = [1,2,3,4;
     5,6,1,NaN];

% verts = [ 2/3+1,  0;
%          -1/3+1,  1/2;
%          -1/3+1, -1/2;
% 
%           2/3-1,  0;
%          -1/3-1,  1/2;
%          -1/3-1, -1/2;];
% faces = [1, 2, 3; % 面1
%          4, 5, 6];

patch('Faces',F,'Vertices',u,'FaceColor','b', 'FaceAlpha',.3)
axis equal
grid on
xline(0);
yline(0);
xlim(2*[-1 1])
ylim(2*[-1 1])

% 
% % 回転
% theta = deg2rad(10);
% Rz = [cos(theta), -sin(theta);
%       sin(theta), cos(theta)];
% 
% newVerts = (Rz*verts')';
% hold on
% patch('Faces',faces,'Vertices',newVerts,'FaceColor','g', 'FaceAlpha',.3)
% 
