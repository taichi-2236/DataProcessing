%% import_foxglove.m
% Foxglove (.mcap / .json / .csv) データを読み込み、ワークスペース変数に展開するスクリプト

%%% 1. 読み込むデータファイルとトピックの指定
datafile = "PushDribble_CircStrt_Out_fix_vx500_NoN11.mcap";
topics   = {'vision', 'referee'};

%%% 2. 変換およびデータ読み込み
logData = load_vision_log(datafile, Topics=topics);

%%% 3. ワークスペースへの変数展開（対話的な確認・後続プロット用）
datafile = logData.csvFile;
data     = logData.table;
robotIds = logData.robotIds;
ball     = logData.ball;
raw_ball = logData.raw_ball;
ref_info = logData.ref_info;

if ~isempty(logData.blue_robot)
    blue_robot = logData.blue_robot;
else
    clear blue_robot;
end
if ~isempty(logData.raw_blue_robot)
    raw_blue_robot = logData.raw_blue_robot;
else
    clear raw_blue_robot;
end
if ~isempty(logData.yellow_robot)
    yellow_robot = logData.yellow_robot;
else
    clear yellow_robot;
end
if ~isempty(logData.raw_yellow_robot)
    raw_yellow_robot = logData.raw_yellow_robot;
else
    clear raw_yellow_robot;
end
