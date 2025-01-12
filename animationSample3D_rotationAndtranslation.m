% 3次元の回転と移動
clear
close all
clc

%% パッチ
% 折り紙飛行機モデル
figure;
p = origami_airplane(1);
axis equal
view(3)
xlabel('x');
ylabel('y');
zlabel('z');

% NED座標に
ax = gca;
ax.YDir = 'reverse';
ax.ZDir = 'reverse';

xlim(1.5*[-1 1])
ylim(1.5*[-1 1])

% 回転+移動
% dx = 0.1;
% dy = 0.2;
% dp = [dx; dy];
% 
% theta = deg2rad(10);
% Rz = [cos(theta), -sin(theta);
%       sin(theta), cos(theta)];
% 
% r = Rz*p + dp;
% 
% hold on
% patch(r(1,:), r(2,:), 'g', 'FaceAlpha',.3);


%% プロペラ
R = 0.25;
N = 15;
phi = linspace(0,2*pi,N);
X = R*cos(phi)';
Y = R*sin(phi)';
Z = zeros(size(X));
V = [0,0,0;
     X,Y,Z];

tmp = (2:N+1)';
F = [ones(N, 1), tmp, circshift(tmp, -1)];  % 面の定義

% F(:,2) = tmp;
% F(:,3) = tmp+1;
% F(:,1) = 1;
% F(end, 3) = 2;  % 最後の面を閉じる
% F = [1, 2, 3;
%      1, 3, 4;
%      1, 4, 5]
hold on

% １つ目のパッチだけ赤に
% RGB 値からなる n×1×3 の配列
col = repmat([0, 1, 0], N,1);
col(1,:) = [1, 0 0];
% col = permute(col, [1, 3, 2]);

prop = patch('Faces', F, 'Vertices', V, ...
             'FaceVertexCData', col, ...
             'FaceColor', 'flat', ...
             'FaceAlpha', .3);