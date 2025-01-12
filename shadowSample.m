clear; clc; close all;

% 光源と頂点の設定
L = [2, 2, 3]; % 光源位置
P = [1, 1, 1]; % 頂点位置

% 地面の関数 z = f(x, y)
f = @(x, y) sin(x) .* cos(y); % 地面の形状
fx = @(x, y) cos(x) .* cos(y); % ∂f/∂x
fy = @(x, y) -sin(x) .* sin(y); % ∂f/∂y

% 地面の範囲
[X, Y] = meshgrid(-4:0.2:4, -4:0.2:4);
Z = f(X, Y);

% 地面の法線ベクトル
nx = fx(P(1), P(2));
ny = fy(P(1), P(2));
nz = 1;
n = [nx, ny, nz];

% 光源から頂点へのベクトル
v = P - L;

% 地面との交点（スケール t の計算）
t = (f(L(1), L(2)) - L(3)) / v(3);

% 影の位置
S = L + t * v;

% プロット
figure;
hold on; grid on; axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
view(3);

% 地面をプロット
surf(X, Y, Z, 'FaceAlpha', 0.7, 'EdgeColor', 'none', 'FaceColor', [0.8 0.8 0.8]);

% 光源、頂点、影をプロット
plot3(L(1), L(2), L(3), 'yo', 'MarkerSize', 10, 'DisplayName', '光源 L');
plot3(P(1), P(2), P(3), 'ro', 'MarkerSize', 10, 'DisplayName', '頂点 P');
plot3(S(1), S(2), S(3), 'go', 'MarkerSize', 10, 'DisplayName', '影 S');

% 光源から頂点、頂点から影への線をプロット
line([L(1), P(1)], [L(2), P(2)], [L(3), P(3)], 'Color', 'blue', 'LineWidth', 1.5, 'DisplayName', '光源→頂点');
line([P(1), S(1)], [P(2), S(2)], [P(3), S(3)], 'Color', 'green', 'LineWidth', 1.5, 'DisplayName', '頂点→影');

legend show;
