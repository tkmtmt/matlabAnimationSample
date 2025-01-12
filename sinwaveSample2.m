% sin波の例(更新)
clear
close all
clc

f = 1;  % [Hz]
dt = 0.01;  %[s]
tEnd = 2;

t = 0:dt:tEnd;
y = sin(2*pi*f*t);

%% アニメーション
nTimes = length(t);

figure;
plot(t,y);  % 線
hold on
p = plot(t(1), y(1), 'o');  % マーカー, t=t(1)

tic
for iTime = 2:nTimes
    p.XData = t(iTime);
    p.YData = y(iTime);
    drawnow;
end
toc