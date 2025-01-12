function convertMp4toGif(fileName)
% ファイル名と拡張子を分離
[pathstr, name, ext] = fileparts(fileName);

outputGif = [name,'.gif'];   % 出力するGIFファイル


% 動画の読み込み
v = VideoReader(fileName);
fps = v.FrameRate;  % GIFのフレームレート

% フレームをループしてGIFを作成
while hasFrame(v)
    frame = readFrame(v);  % フレームを取得
    img = imresize(frame, [360, NaN]); % サイズ調整（オプション）
    [A, map] = rgb2ind(img, 256);      % RGBをインデックスカラーに変換
    
    % GIFとして保存
    if v.CurrentTime == v.Duration / v.NumFrames
        imwrite(A, map, outputGif, 'gif', 'LoopCount', Inf, 'DelayTime', 1/fps);
    else
        imwrite(A, map, outputGif, 'gif', 'WriteMode', 'append', 'DelayTime', 1/fps);
    end
end

disp('GIFの作成が完了しました');

end