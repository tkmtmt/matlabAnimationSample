% 動画ファイル作成サンプル
clear
close all
clc

f = 1;  % [Hz]
dt = 0.01;  %[s]
tEnd = 2;

t = 0:dt:tEnd;
y = sin(2*pi*f*t);

%% アニメーション
isOutput = 1;
fileName = "sinwave.mp4";
fps = 1/dt;

if isOutput
    v = VideoWriter(fileName, 'MPEG-4');
    v.FrameRate = fps;
    open(v);
end

nTimes = length(t);

figure;
plot(t,y);  % 線
hold on
p = plot(t(1), y(1), 'o');  % マーカー, t=t(1)

for iTime = 1:nTimes
    p.XData = t(iTime);
    p.YData = y(iTime);
    drawnow;

    if isOutput
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
end

if isOutput
    close(v);
end