% 2次元の回転と移動
clear
close all
clc

% 1点の例
p = [1;
     0];

figure;
plot(p(1), p(2), 'o');
axis equal
xline(0);
yline(0);
xlim(1.5*[-1 1])
ylim(1.5*[-1 1])
xlabel("x");
ylabel("y");
grid on

%% 回転
theta = deg2rad(30);
Rz = [cos(theta), -sin(theta);
      sin(theta), cos(theta)];
q = Rz*p;

hold on
plot(q(1), q(2), 'or')

%% 移動
dx = -2;
dy = 0.5;
t = [dx;
     dy];
r = Rz*p + t;
plot(r(1), r(2), 'o');

%% 同次変換行列
P = [p;1];
RZ = Rz;
RZ(3,3) = 1;
T = eye(3);
T(1:2,3) = t;
H = [Rz,t];
H(3,3) = 1;

figure;
plot(P(1), P(2), 'o');
axis equal
xline(0);
yline(0);
xlim(1.5*[-1 1])
ylim(1.5*[-1 1])
xlabel("x");
ylabel("y");
grid on

% Q = T*RZ*P;
Q = H*P;

hold on
plot(Q(1), Q(2), 'or')