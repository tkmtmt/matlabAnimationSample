% sin波の例(削除と描画)
clear
close all
clc

f = 1;  % [Hz]
dt = 0.01;  %[s]
tEnd = 2;

t = 0:dt:tEnd;
y = sin(2*pi*f*t);

% 確認
figure;
plot(t,y);

%% アニメーション
nTimes = length(t);

figure;
plot(t,y);  % 線
hold on
plot(t(1), y(1), 'o');  % マーカー, t=t(1)

tic
for iTime = 2:nTimes
    clf % 消す

    % 再描画
    plot(t,y);  % 線
    hold on
    plot(t(iTime), y(iTime), 'o');  % マーカー, t=t(i)
    drawnow;
end
toc