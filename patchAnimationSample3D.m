% ３次元アニメーション

clear
close all
clc

dt = 0.05;
tEnd = 10;
t = 0:dt:tEnd;

R = 3;
v = 10;
omega = v/R;
H = 1;

x = R*cos(omega*t);
y = R*sin(omega*t);
z = -H*ones(size(x));

phi = pi/8*ones(size(x));
theta = pi/8*ones(size(x));
psi = omega*t + pi/2;

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

xlim(5*[-1 1])
ylim(5*[-1 1])
% zlim(3*[-1 1])

lighting gouraud
light(ax,"Position",[0,0,-1]);

nTimes = length(t);
origVert = pat.Vertices;
for i = 1:nTimes
    Rx = [1, 0, 0;
          0, cos(phi(i)), -sin(phi(i));
          0, sin(phi(i)), cos(phi(i))];

    Ry = [cos(theta(i)), 0, sin(theta(i));
          0, 1, 0;
          -sin(theta(i)), 0 , cos(theta(i))];

    Rz = [cos(psi(i)), -sin(psi(i)), 0;
          sin(psi(i)), cos(psi(i)), 0;
          0, 0, 1];

    pat.Vertices = (Rz*Ry*Rx*origVert')' + [x(i),y(i),z(i)];
    drawnow;
    pause(dt);
end