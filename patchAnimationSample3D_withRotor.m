% 同次変換行列
% ローター

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

figure("WindowState","maximized");
pat = A1200(1);
A1200OrigV = pat.Vertices;
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

% xlim(5*[-1 1])
% ylim(5*[-1 1])
% zlim(3*[-1 1])

lighting gouraud
light(ax,"Position",[0,0,-1]);

%% プロペラ
prop = propeller(0.07);
propOrigV = prop.Vertices;
T0 = [-0.18;
     0;
     -0.1];

Ry0 = [cos(5*pi/8), 0, sin(5*pi/8);
      0, 1, 0;
      -sin(5*pi/8), 0 , cos(5*pi/8)];
% 
% prop.Vertices = (Ry0*prop.Vertices')' + T0';

nTimes = length(t);
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
    R = Rz*Ry*Rx;

    psi0 = mod(2*pi/15*(i-1),2*pi);
    Rz0 = [cos(psi0), -sin(psi0), 0;
          sin(psi0), cos(psi0), 0;
          0, 0, 1];
    R0 = Ry0*Rz0;
    
    % 同次変換行列の作成
    H0 = R0;
    H0(4,4) = 1;
    H0(1:3,4) = T0;

    H = R;
    H(4,4) = 1;
    H(1:3,4) = [x(i);y(i);z(i)];

    % 同次変換行列による変換
    verts = [propOrigV,ones(size(propOrigV,1),1)];    % 4列に拡張
    newVerts = (H*H0*verts')';
    prop.Vertices = newVerts(:,1:3);

    verts = [A1200OrigV,ones(size(A1200OrigV,1),1)];    % 4列に拡張
    newVerts = (H*verts')';
    pat.Vertices = newVerts(:,1:3);

    % prop.Vertices = (Ry0*Rz0*propOrigV')'+l'; % プロペラ回転だけ


    % prop.Vertices = (R*(R0*propOrigV'+T0))' + [x(i),y(i),z(i)];
    % pat.Vertices = (R*A1200OrigV')' + [x(i),y(i),z(i)];
    drawnow;
    pause(dt);
end