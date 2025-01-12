clear; clc; close all;

% 光源の位置
L = [0, 0, 10]; % 光源位置

% 地面の離散データ
[X, Y] = meshgrid(-4:0.05:4, -4:0.05:4); % MESHGRID形式
Z = sin(X) .* cos(Y); % 地面の形状

% MESHGRID -> NDGRID 形式に変換
X = X'; Y = Y'; Z = Z';

% 地面の補間関数
f_interp = griddedInterpolant(X, Y, Z, 'spline', 'none'); % 地面の高さを補間

% 球の定義
sphereCenter = [0, 0, 3]; % 球の中心
sphereRadius = 1; % 球の半径
[XS, YS, ZS] = sphere(50); % 球の離散的な表面
XS = sphereRadius * XS + sphereCenter(1);
YS = sphereRadius * YS + sphereCenter(2);
ZS = sphereRadius * ZS + sphereCenter(3);

% 地面のカラーデータ（初期状態で均一）
C = ones(size(Z)); % 全体を1（白）に設定

% 各地面格子点について影を計算
for i = 1:size(X, 1)
    for j = 1:size(X, 2)
        % 地面の現在の格子点
        groundPoint = [X(i, j), Y(i, j), Z(i, j)];

        % 光線を地面の点から逆にトレース
        v = L - groundPoint;

        % 球との交差判定
        t = checkSphereIntersection(sphereCenter, sphereRadius, groundPoint, v);
        if t > 0 % 交差していれば影を設定
            C(i, j) = 0; % 影の部分を黒に設定
        end
    end
end

% プロット設定
figure;
hold on; grid on; axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
view(3);

% 地面をプロット（色データを利用）
surf(X', Y', Z', C', 'FaceAlpha', 0.9, 'EdgeColor', 'none', ...
    'FaceColor', 'interp', 'FaceLighting', 'gouraud', ...
    'SpecularStrength', 0.5, 'DiffuseStrength', 0.8);

% 球をプロット
surf(XS, YS, ZS, 'EdgeColor', 'none', ...
    'FaceColor', 'blue', 'FaceAlpha', 0.8, 'FaceLighting', 'gouraud', ...
    'SpecularStrength', 0.5, 'DiffuseStrength', 0.8);

% 光源をプロット
plot3(L(1), L(2), L(3), 'yo', 'MarkerSize', 10, 'MarkerFaceColor', 'yellow', 'DisplayName', '光源 L');

% 光源を追加
light('Position', [10 10 10], 'Style', 'infinite'); % 遠方光源
light('Position', [-10 -10 10], 'Style', 'local');   % 局所光源

% 材質設定
material('shiny'); % 表面の光沢を強調

legend show;

%% 関数: 球との交差判定
function t = checkSphereIntersection(center, radius, point, direction)
    % 球との交差判定 (t > 0 のとき交差)
    oc = point - center; % 球の中心から点までのベクトル
    a = dot(direction, direction);
    b = 2.0 * dot(oc, direction);
    c = dot(oc, oc) - radius^2;
    discriminant = b^2 - 4*a*c;

    if discriminant < 0
        t = -1; % 交差なし
    else
        t = (-b - sqrt(discriminant)) / (2.0 * a); % 交差距離
    end
end
