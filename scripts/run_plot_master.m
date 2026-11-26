%% run_plot_master.m
% 1台のロボットで実験した際のロボットとボールの軌跡をプロットするスクリプト
% （先に import_foxglove.m 等でワークスペースにデータを展開してから実行してください）

%%% 1. 描画・区間分割オプション設定
splitMultipleRuns = false;         % true の場合は不連続なReady区間を別々の実験として分割
useRawData        = true;         % true の場合は生データ (q_r_raw, q_b_raw) を描画に使用
targetTraj        = traj.preset("CircStrt_Out");
% プリセットやカスタム経路の指定例:
% targetTraj = traj.preset("Circle");
% targetTraj = { ...
%     traj.Line([-0.5; 1.0], [-0.5; 1.0 - sqrt(3)/2]), ...
%     traj.Arc([0.0; 1.0], 1.0, AngleRange=[0, pi]) ...
% };
xLimRange         = [-2.75, 1.75];
yLimRange         = [-1.75, 1.75];
directionFrames   = [];            % 姿勢方向を描くフレーム例: 10:20:600
velocityFrames    = [];            % 並進速度を描くフレーム例: 10:20:600
robotBallFrames   = [];            % 機体イメージを描くフレーム例: [1, 45]
savePdf           = true;
cropPdf           = true;

%%% 2. インデックス定数の準備と対象区間 (Ready) の抽出
clear q_r v_r q_b v_b q_r_raw v_r_raw q_b_raw v_b_raw;
r   = index.RobotIdx;
b   = index.BallIdx;
ref = index.RefInfoIdx;

if ~exist('ref_info', 'var') || isempty(ref_info)
    error('ref_info が空または未定義です。先に import_foxglove.m を実行してください。');
end

active_seq = str2double(ref_info(ref_info(:, ref.cmd) == "Ready", ref.seq));
if isempty(active_seq)
    error('Referee情報内に "Ready" コマンドの区間が見つかりませんでした。');
end

if splitMultipleRuns
    split_idxs = find_discontinuous_idx(active_seq);
    split_edge_idx = [active_seq(split_idxs(:,1)), active_seq(split_idxs(:,2))];
else
    split_edge_idx = [active_seq(1), active_seq(end)];
end

%%% 3. 分割された実験ごとにデータ抽出・プロット
nRuns = size(split_edge_idx, 1);
for k = 1:nRuns
    start  = split_edge_idx(k, 1);
    finish = split_edge_idx(k, 2);

    if nRuns > 1
        [dirPath, name, ext] = fileparts(datafile);
        runDataFile = fullfile(dirPath, append(name, "_", string(k), ext));
    else
        runDataFile = datafile;
    end

    % 記録されているチームカラーのロボット姿勢・並進速度を格納
    if exist('yellow_robot', 'var') && ~isempty(yellow_robot)
        robotSrc = yellow_robot(:, :, 1);
    elseif exist('blue_robot', 'var') && ~isempty(blue_robot)
        robotSrc = blue_robot(:, :, 1);
    else
        error('yellow_robot / blue_robot のいずれもワークスペースに存在しません。');
    end

    q_r = [robotSrc(start:finish, r.x:r.y) / 1000, robotSrc(start:finish, r.angle)];
    v_r = robotSrc(start:finish, r.vx:r.vy) / 1000;

    % ロボットの生データ姿勢・並進速度を格納
    if exist('raw_yellow_robot', 'var') && ~isempty(raw_yellow_robot)
        rawRobotSrc = raw_yellow_robot(:, :, 1);
        q_r_raw = [rawRobotSrc(start:finish, r.x:r.y) / 1000, rawRobotSrc(start:finish, r.angle)];
        v_r_raw = rawRobotSrc(start:finish, r.vx:r.vy) / 1000;
    elseif exist('raw_blue_robot', 'var') && ~isempty(raw_blue_robot)
        rawRobotSrc = raw_blue_robot(:, :, 1);
        q_r_raw = [rawRobotSrc(start:finish, r.x:r.y) / 1000, rawRobotSrc(start:finish, r.angle)];
        v_r_raw = rawRobotSrc(start:finish, r.vx:r.vy) / 1000;
    else
        q_r_raw = [];
        v_r_raw = [];
    end

    % ボール座標・速度を格納（フィルタ済み / 生データ）
    if exist('ball', 'var') && ~isempty(ball)
        q_b = ball(start:finish, b.x:b.y) / 1000;
        v_b = ball(start:finish, b.vx:b.vy) / 1000;
    else
        q_b = [];
        v_b = [];
    end
    if exist('raw_ball', 'var') && ~isempty(raw_ball)
        q_b_raw = raw_ball(start:finish, b.x:b.y) / 1000;
        v_b_raw = raw_ball(start:finish, b.vx:b.vy) / 1000;
    else
        q_b_raw = [];
        v_b_raw = [];
    end

    % 描画に使うデータを選択
    if useRawData
        plotQr = q_r_raw;
        plotVr = v_r_raw;
        plotQb = q_b_raw;
    else
        plotQr = q_r;
        plotVr = v_r;
        plotQb = q_b;
    end

    % 軌跡図の生成
    plot_orbit(plotQr, plotQb, ...
        TargetTraj      = targetTraj, ...
        XLim            = xLimRange, ...
        YLim            = yLimRange, ...
        DirectionFrames = directionFrames, ...
        VelocityFrames  = velocityFrames, ...
        RobotVel        = plotVr, ...
        RobotBallFrames = robotBallFrames, ...
        DataFile        = runDataFile, ...
        SaveFigure      = savePdf, ...
        CropFigure      = cropPdf);

    % 誤差グラフを合わせて出力する場合の例:
    % err = hypot(q_b(:,1), q_b(:,2) - 1.0) - 1.0;
    % plot_err_traj2ball((1:size(q_b,1))/60, err, DataFile=runDataFile, SaveFigure=savePdf);
end

%%% 4. 一時変数の整理（最後の実験の q_r, v_r, q_b, v_b および *_raw は確認用に残す）
clear r b ref start finish active_seq split_edge_idx split_idxs nRuns k runDataFile dirPath name ext robotSrc rawRobotSrc plotQr plotVr plotQb;
