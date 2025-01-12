clear; clc; close all;

% 光源と頂点の設定
L = [2, 2, 3]; % 光源位置
P = [1, 1, 1]; % 頂点位置

% 地面の離散データ
[X, Y] = meshgrid(-4:0.5:4, -4:0.5:4); % MESHGRID 形式
Z = sin(X) .* cos(Y); % 離散的な地面形状

% MESHGRID -> NDGRID 形式に変換
X = X'; Y = Y'; Z = Z';

% 光源から頂点へのベクトル
v = P - L;

% 補間を用いた地面高さの取得
f_interp = griddedInterpolant(X, Y, Z, 'linear', 'none'); % 線形補間
z_ground = f_interp(P(1), P(2)); % 頂点 P の地面高さ

% 法線ベクトルの計算（差分を用いた近似）
[nx, ny, nz] = calculateNormal(P(1), P(2), X, Y, Z);
n = [nx, ny, nz]; % 法線ベクトル

% 地面との交点（スケール t の計算）
t = (z_ground - L(3)) / v(3);

% 影の位置
S = L + t * v;

% プロット
figure;
hold on; grid on; axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
view(3);

% 地面をプロット
surf(X', Y', Z', 'FaceAlpha', 0.7, 'EdgeColor', 'none', 'FaceColor', [0.8 0.8 0.8]);

% 光源、頂点、影をプロット
plot3(L(1), L(2), L(3), 'yo', 'MarkerSize', 10, 'DisplayName', '光源 L');
plot3(P(1), P(2), P(3), 'ro', 'MarkerSize', 10, 'DisplayName', '頂点 P');
plot3(S(1), S(2), S(3), 'go', 'MarkerSize', 10, 'DisplayName', '影 S');

% 光源から頂点、頂点から影への線をプロット
line([L(1), P(1)], [L(2), P(2)], [L(3), P(3)], 'Color', 'blue', 'LineWidth', 1.5, 'DisplayName', '光源→頂点');
line([P(1), S(1)], [P(2), S(2)], [P(3), S(3)], 'Color', 'green', 'LineWidth', 1.5, 'DisplayName', '頂点→影');

legend show;

%% 関数: 法線ベクトルを計算
function [nx, ny, nz] = calculateNormal(x, y, X, Y, Z)
    % 近傍のグリッド点を検索
    [~, i] = min(abs(X(1, :) - x));
    [~, j] = min(abs(Y(:, 1) - y));

    % 差分法による法線計算
    if i < size(X, 2) && j < size(Y, 1)
        dz_dx = (Z(j, i+1) - Z(j, i)) / (X(j, i+1) - X(j, i));
        dz_dy = (Z(j+1, i) - Z(j, i)) / (Y(j+1, i) - Y(j, i));
    else
        dz_dx = 0;
        dz_dy = 0;
    end

    % 法線ベクトル
    nx = -dz_dx;
    ny = -dz_dy;
    nz = 1;

    % 正規化
    norm_factor = sqrt(nx^2 + ny^2 + nz^2);
    nx = nx / norm_factor;
    ny = ny / norm_factor;
    nz = nz / norm_factor;
end
