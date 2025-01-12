% ３次元の回転と移動
clear
close all
clc

% 折り紙飛行機モデル
figure;
pat = origami_airplane(1);
% pat = A1200(1);
axis equal
grid on
view(3)
xlabel('x');
ylabel('y');
zlabel('z');

% NED座標に
ax = gca;
ax.XDir = 'reverse';
ax.ZDir = 'reverse';

xlim(1.5*[-1 1])
ylim(1.5*[-1 1])
zlim(1.5*[-1 1])

lighting gouraud
light(ax,"Position",[0,0,-1]);

%% x軸周りの回転
phi = deg2rad(30);
Rx = [1, 0, 0;
      0, cos(phi), -sin(phi);
      0, sin(phi), cos(phi)];

pat.Vertices = (Rx*pat.Vertices')';

%% y軸周りの回転
theta = deg2rad(30);
Ry = [cos(theta), 0, sin(theta);
      0, 1, 0;
      -sin(theta),0 , cos(theta)];

pat.Vertices = (Ry*pat.Vertices')';

%% z軸周りの回転
psi = deg2rad(30);
Rz = [cos(psi), -sin(psi), 0;
      sin(psi), cos(psi), 0;
      0, 0, 1];

pat.Vertices = (Rz*pat.Vertices')';

%% 平行移動
t = [0.1;
     0.2;
     0.3];
pat.Vertices = pat.Vertices + t';
