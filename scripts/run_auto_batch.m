%% run_auto_batch.m
% 指定パターンに一致する複数のログファイルを一括で変換・軌跡プロットするスクリプト

close all;

paths      = Constants.FileParam();
pattern    = fullfile(paths.DataMcapDir, "PushDribble_Circ_*_initerr*_NoN11.mcap");
topics     = {'vision', 'referee'};
targetTraj = traj.preset("Circle");

files = dir(pattern);
if isempty(files)
    warning('対象パターンに一致するファイルが見つかりませんでした:\n%s', pattern);
end

r   = index.RobotIdx;
b   = index.BallIdx;
ref = index.RefInfoIdx;

for i = 1:numel(files)
    inputPath = fullfile(files(i).folder, files(i).name);
    disp("Processing : " + files(i).name);

    logData = load_vision_log(inputPath, Topics=topics);

    active_seq = str2double(logData.ref_info(logData.ref_info(:, ref.cmd) == "Ready", ref.seq));
    if isempty(active_seq)
        warning('Ready区間が見つからないためスキップします: %s', files(i).name);
        continue;
    end

    start  = active_seq(1);
    finish = active_seq(end);

    if ~isempty(logData.yellow_robot)
        robotSrc = logData.yellow_robot(:, :, 1);
    elseif ~isempty(logData.blue_robot)
        robotSrc = logData.blue_robot(:, :, 1);
    else
        warning('ロボットデータが見つからないためスキップします: %s', files(i).name);
        continue;
    end

    q_r = [robotSrc(start:finish, r.x:r.y) / 1000, robotSrc(start:finish, r.angle)];
    v_r = robotSrc(start:finish, r.vx:r.vy) / 1000;
    q_b = logData.ball(start:finish, b.x:b.y) / 1000;

    fig = plot_orbit(q_r, q_b, ...
        TargetTraj = targetTraj, ...
        RobotVel   = v_r, ...
        DataFile   = logData.csvFile, ...
        SaveFigure = true, ...
        CropFigure = true);
    close(fig);
end
