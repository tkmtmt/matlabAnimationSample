clear; clc; close all;

% 光源の位置
L = [2, 2, 5]; % 光源位置

% 地面の離散データ
[X, Y] = meshgrid(-4:0.1:4, -4:0.1:4); % MESHGRID形式
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

% 影を格納する変数
shadowPoints = []; % 影の点群を格納

% 各点の影を計算
for i = 1:size(XS, 1)
    for j = 1:size(XS, 2)
        % 球の現在の頂点
        P = [XS(i, j), YS(i, j), ZS(i, j)];

        % 光源から頂点へのベクトル
        v = P - L;

        % 補間を用いた地面との交点
        t = findIntersection(L, v, f_interp);
        if ~isnan(t) % 有効な交点のみ処理
            S = L + t * v; % 交点の座標
            shadowPoints = [shadowPoints; S]; % 点群に追加
        end
    end
end

% 影の点群を取得
shadowX = shadowPoints(:, 1);
shadowY = shadowPoints(:, 2);
shadowZ = shadowPoints(:, 3);

% グリッド化して `surf` で描画
[xq, yq] = meshgrid(linspace(min(shadowX), max(shadowX), 100), ...
                    linspace(min(shadowY), max(shadowY), 100));
zq = griddata(shadowX, shadowY, shadowZ, xq, yq, 'linear');

% プロット設定
figure;
hold on; grid on; axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
view(3);

% 地面をプロット
surf(X', Y', Z'-0.3, 'FaceAlpha', 0.9, 'EdgeColor', 'none', ...
    'FaceColor', [0.8 0.8 0.8], 'FaceLighting', 'gouraud', ...
    'SpecularStrength', 0.5, 'DiffuseStrength', 0.8);

% 球をプロット
surf(XS, YS, ZS, 'EdgeColor', 'none', ...
    'FaceColor', 'blue', 'FaceAlpha', 0.8, 'FaceLighting', 'gouraud', ...
    'SpecularStrength', 0.5, 'DiffuseStrength', 0.8);

% 光源をプロット
plot3(L(1), L(2), L(3), 'yo', 'MarkerSize', 10, 'MarkerFaceColor', 'yellow', 'DisplayName', '光源 L');

% 影をプロット (surfを使用)
surf(xq, yq, zq, 'EdgeColor', 'none', ...
    'FaceColor', [0, 0, 0], 'FaceAlpha', 0.5, 'FaceLighting', 'gouraud');

% 光源を追加
light('Position', [10 10 10], 'Style', 'infinite'); % 遠方光源
light('Position', [-10 -10 10], 'Style', 'local');   % 局所光源

% 材質設定
material('shiny'); % 表面の光沢を強調

legend show;

%% 関数: 地面との交点を計算
function t = findIntersection(L, v, f_interp)
    % ニュートン法の初期設定
    t = 1;
    tol = 1e-5;
    maxIter = 50;

    for iter = 1:maxIter
        % 現在の影の位置
        x = L(1) + t * v(1);
        y = L(2) + t * v(2);
        z = L(3) + t * v(3);

        % 地面の高さを補間
        try
            z_ground = f_interp(x, y);
        catch
            t = NaN; % 範囲外のとき無効値を返す
            return;
        end

        % 更新ステップ
        delta = (z - z_ground) / v(3);
        t = t - delta;

        % 収束判定
        if abs(delta) < tol
            return; % 解が収束した場合
        end
    end
    t = NaN; % 収束しない場合
end
