clear
close all
clc

% 図形の作成
figure;
ax = gca;
grid on;
hold on;
view(3); % 3次元表示

% 軸のプロパティを設定
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
ax.XLim = [-4, 4];
ax.YLim = [-4, 4];
ax.ZLim = [-0.1, 4];

% 光源の位置
lightPos = [0, 0, 4];
% light('Position',[0,0,1])
plot3(lightPos(1), lightPos(2), lightPos(3), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'yellow');

% 地面の作成
[X, Y] = meshgrid(-4:0.5:4, -4:0.5:4);
Z = -0.1 * ones(size(X)); % 地面は z=-0.1 に設定
surf(X, Y, Z, 'FaceColor', [0.8 0.8 0.8], 'EdgeColor', 'none'); % 地面

% ベースの座標系
base = hgtransform('Parent', ax);

% 第一リンクの座標系
link1 = hgtransform('Parent', base);
T1 = makehgtform('translate', [0., 0., 0]); % link1をbaseの原点から平行移動
set(link1, 'Matrix', T1);

% 第一リンクの図形
L1 = 0.5; % 第一リンクの長さ
[X1, Y1, Z1] = createCylinder([0, 0, 0], [0, 0, L1], 0.1, 'red', link1);

% 第二リンクの座標系
link2 = hgtransform('Parent', link1);

% 第二リンクの図形
L2 = 1; % 第二リンクの長さ
[X2, Y2, Z2] = createCylinder([0, 0, 0], [0, 0, L2], 0.1, 'blue', link2);

% 第三リンクの座標系
link3 = hgtransform('Parent', link2);

% 第三リンクの図形
L3 = 1.5; % 第三リンクの長さ
[X3, Y3, Z3] = createCylinder([0, 0, 0], [0, 0, L3], 0.1, 'green', link3);

%% 座標変換
% 初期回転
R1 = make3dRotation(deg2rad(0), deg2rad(0), deg2rad(0));
H1 = T1 * R1; % 平行移動と回転を組み合わせ
set(link1, 'Matrix', H1);

% 第二リンクの回転
T2 = makehgtform('translate', [0, 0, L1]);
R2 = make3dRotation(0, deg2rad(0), deg2rad(0));
H2 = T2 * R2;
set(link2, 'Matrix', H2);

% 第三リンクの回転
T3 = makehgtform('translate', [0, 0, L2]);
R3 = make3dRotation(0, deg2rad(-90), deg2rad(0));
H3 = T3 * R3;
set(link3, 'Matrix', H3);

%% 初期の影を作成
shadowHandles(1) = projectShadow(X1, Y1, Z1, lightPos, [0.1, 0.1, 0.1], 0.5, link1);
shadowHandles(2) = projectShadow(X2, Y2, Z2, lightPos, [0.1, 0.1, 0.1], 0.5, link2);
shadowHandles(3) = projectShadow(X3, Y3, Z3, lightPos, [0.1, 0.1, 0.1], 0.5, link3);

%% アニメーション
frames = 100; % アニメーションのフレーム数
yawAngles = linspace(0, 2*pi, frames); % ヨー角を0から360度まで回転

for k = 1:frames
    % link1をヨー角で回転
    R_yaw = makehgtform('xrotate', yawAngles(k));
    H1 = T1 * R1 * R_yaw; % 平行移動 + 初期回転 + ヨー回転
    set(link1, 'Matrix', H1);
    
    % link1の影を更新
    updateShadow(shadowHandles(1), X1, Y1, Z1, lightPos, link1);
    % link2の影を更新
    updateShadow(shadowHandles(2), X2, Y2, Z2, lightPos, link2);
    % link3の影を更新
    updateShadow(shadowHandles(3), X3, Y3, Z3, lightPos, link3);

    pause(0.05); % 描画間隔
end

%% カスタム関数: 円柱を作成 (影対応)
function [X, Y, Z] = createCylinder(base, top, radius, color, parent)
    [X, Y, Z] = cylinder(radius);
    Z = Z * norm(top - base);
    X = X + base(1);
    Y = Y + base(2);
    Z = Z + base(3);
    surf(X, Y, Z, ...
        'FaceColor', color, ...
        'EdgeColor', 'none', ...
        'Parent', parent, ...
        'FaceLighting', 'gouraud', ...
        'SpecularStrength', 0.5, ...
        'DiffuseStrength', 0.8, ...
        'AmbientStrength', 0.3);
end

%% 影を計算して描画
function h = projectShadow(X, Y, Z, lightPos, shadowColor, alphaVal, hgTransformObj)
    % 階層的な変換行列を計算
    transformMatrix = hgtransformChainMatrix(hgTransformObj);
    numPoints = numel(X);
    points = [X(:), Y(:), Z(:), ones(numPoints, 1)]'; % 4xNの座標行列
    transformedPoints = transformMatrix * points; % 全体の座標変換
    X = reshape(transformedPoints(1, :), size(X));
    Y = reshape(transformedPoints(2, :), size(Y));
    Z = reshape(transformedPoints(3, :), size(Z));

    % 光源から地面への影を計算
    [rows, cols] = size(X);
    shadowX = zeros(rows, cols);
    shadowY = zeros(rows, cols);
    shadowZ = -0.1 * ones(rows, cols); % 地面 (z=-0.1) に影を落とす
    
    for i = 1:rows
        for j = 1:cols
            t = (shadowZ(i, j) - Z(i, j)) / (lightPos(3) - Z(i, j)); % 投影スケール
            shadowX(i, j) = X(i, j) + t * (lightPos(1) - X(i, j));
            shadowY(i, j) = Y(i, j) + t * (lightPos(2) - Y(i, j));
        end
    end
    
    % 影を描画
    h = surf(shadowX, shadowY, shadowZ, ...
        'FaceColor', shadowColor, ...
        'EdgeColor', 'none', ...
        'FaceAlpha', alphaVal);
end

%% 影を更新
function updateShadow(h, X, Y, Z, lightPos, hgTransformObj)
    % 影の座標を更新
    transformMatrix = hgtransformChainMatrix(hgTransformObj);
    numPoints = numel(X);
    points = [X(:), Y(:), Z(:), ones(numPoints, 1)]';
    transformedPoints = transformMatrix * points;
    X = reshape(transformedPoints(1, :), size(X));
    Y = reshape(transformedPoints(2, :), size(Y));
    Z = reshape(transformedPoints(3, :), size(Z));

    % 光源から地面への影を再計算
    shadowX = zeros(size(X));
    shadowY = zeros(size(Y));
    shadowZ = -0.0 * ones(size(Z)); % 地面 (z=-0.1)

    for i = 1:size(X, 1)
        for j = 1:size(X, 2)
            t = (shadowZ(i, j) - Z(i, j)) / (lightPos(3) - Z(i, j)); % 投影スケール
            shadowX(i, j) = X(i, j) + t * (lightPos(1) - X(i, j));
            shadowY(i, j) = Y(i, j) + t * (lightPos(2) - Y(i, j));
        end
    end

    % 影の座標を更新
    set(h, 'XData', shadowX, 'YData', shadowY, 'ZData', shadowZ);
end

%% 階層的な変換行列を計算
function fullMatrix = hgtransformChainMatrix(hgTransformObj)
    % 親の変換行列を考慮して階層的に行列を計算
    fullMatrix = eye(4);
    while ~isempty(hgTransformObj) && ~isa(hgTransformObj, 'matlab.graphics.axis.Axes')
        if isvalid(hgTransformObj) % 無効なオブジェクトをスキップ
            fullMatrix = get(hgTransformObj, 'Matrix') * fullMatrix;
        end
        hgTransformObj = get(hgTransformObj, 'Parent');
    end
end

function R_total = make3dRotation(roll, pitch, yaw)
    R_roll = makehgtform('xrotate', roll);
    R_pitch = makehgtform('yrotate', pitch);
    R_yaw = makehgtform('zrotate', yaw);
    R_total = R_yaw * R_pitch * R_roll;
end
