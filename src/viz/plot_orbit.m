%% plot_orbit
% ロボットとボールの軌跡図および付随ベクトル・機体イメージを描画する関数
%
% 引数:
%   q_r : ロボット姿勢時系列 [N x 3] (x [m], y [m], angle [rad])
%   q_b : ボール位置時系列   [N x 2] (x [m], y [m], 空の場合はスキップ)
%   Opts: 描画・保存オプション (Name-Value)
function fig = plot_orbit(q_r, q_b, Opts)
    arguments
        q_r double
        q_b double = []
        Opts.ShowField       (1,1) logical = true
        Opts.ShowTarget      (1,1) logical = true
        Opts.TargetTraj                    = {}
        Opts.DirectionFrames double        = []
        Opts.VelocityFrames  double        = []
        Opts.RobotVel        double        = []
        Opts.RobotBallFrames double        = []
        Opts.XLim            double        = [-1.75, 1.75]
        Opts.YLim            double        = [-0.75, 2.75]
        Opts.XTicks          double        = []
        Opts.YTicks          double        = []
        Opts.LegendLocation  (1,1) string  = "northeast"
        Opts.DataFile        (1,1) string  = ""
        Opts.OutputDir       (1,1) string  = ""
        Opts.OutputTag       (1,1) string  = "track_"
        Opts.SaveFigure      (1,1) logical = true
        Opts.CropFigure      (1,1) logical = true
    end

    fig = figure;
    legend_tag = string.empty(1, 0);

    % 1. フィールド描画
    if Opts.ShowField
        plot_field();
    end

    grid on;
    hold on;

    % 2. 目標経路描画
    if Opts.ShowTarget
        plotTargetTrajection(Opts.TargetTraj);
        legend_tag(end+1) = "reference path for ball";
    end

    % 3. ロボットの軌跡描画
    if ~isempty(q_r)
        plot(q_r(:,1), q_r(:,2), '-', 'LineWidth', 2, 'Color', '#007FFF');
        legend_tag(end+1) = "robot";
    end

    % 4. ボールの軌跡描画
    if ~isempty(q_b)
        plot(q_b(:,1), q_b(:,2), '-', 'LineWidth', 2, 'Color', '#FF8F00');
        legend_tag(end+1) = "ball";
    end

    % 5. 指定frame時のロボット姿勢角方向を描画
    if ~isempty(Opts.DirectionFrames) && ~isempty(q_r)
        plotRobotDirection(Opts.DirectionFrames, q_r);
    end

    % 6. 指定frame時のロボット並進速度を描画
    if ~isempty(Opts.VelocityFrames) && ~isempty(Opts.RobotVel) && ~isempty(q_r)
        plotRobotVelocity(Opts.VelocityFrames, q_r, Opts.RobotVel);
    end

    % 7. 指定frame時のロボットとボールのイメージを描画
    if ~isempty(Opts.RobotBallFrames) && ~isempty(q_r) && ~isempty(q_b)
        plotRobotAndBall(Opts.RobotBallFrames, q_r, q_b);
    end

    % 8. グラフのプロパティ設定
    xlabel('x (m)');
    ylabel('y (m)');
    axis equal;
    if numel(Opts.XLim) == 2
        xlim(Opts.XLim);
    end
    if numel(Opts.YLim) == 2
        ylim(Opts.YLim);
    end
    if ~isempty(Opts.XTicks)
        xticks(Opts.XTicks);
    end
    if ~isempty(Opts.YTicks)
        yticks(Opts.YTicks);
    end
    if ~isempty(legend_tag)
        legend(legend_tag, "Location", Opts.LegendLocation);
    end
    hold off;

    set(gca, 'FontSize', 20);
    set(gcf, 'PaperOrientation', 'landscape');

    % 9. PDF出力
    if Opts.SaveFigure && Opts.DataFile ~= ""
        output_figure(Opts.DataFile, Opts.OutputDir, Opts.OutputTag, Opts.CropFigure);
    end
end

%% ローカル描画ヘルパー関数群

function plotTargetTrajection(targetTraj)
    if isempty(targetTraj)
        segments = traj.preset("Circle");
    elseif isstring(targetTraj) || ischar(targetTraj)
        segments = traj.preset(string(targetTraj));
    elseif iscell(targetTraj)
        segments = targetTraj;
    else
        segments = {targetTraj};
    end

    for i = 1:numel(segments)
        seg = segments{i};
        [tx, ty] = seg.samplePoints();
        if i == 1
            vis = 'on';
        else
            vis = 'off';
        end
        plot(tx, ty, ...
            'LineStyle', seg.LineStyle, ...
            'Color', seg.Color, ...
            'LineWidth', seg.LineWidth, ...
            'HandleVisibility', vis);
    end
end

function plotRobotAndBall(frame_idxs, q_r, q_b)
    marker_size = 18.0;
    nFrames = size(q_r, 1);
    validIdxs = frame_idxs(frame_idxs >= 1 & frame_idxs <= nFrames);
    for idx = validIdxs(:)'
        p = plot(q_b(idx,1), q_b(idx,2), 'Marker', 'o', ...
            'MarkerFaceColor', '#FF8F00', 'MarkerEdgeColor', '#000000', 'HandleVisibility', 'off');
        p.MarkerSize = marker_size;
        h = sslrobot(q_r(idx,1), q_r(idx,2), q_r(idx,3));
        set(h, 'HandleVisibility', 'off');
        str = "t = " + round(idx / 60.0, 3) + "s";
        txt = text(q_r(idx,1) - 0.25, q_r(idx,2), str);
        fontsize(txt, 15, "pixels");
    end
end

function plotRobotDirection(frame_idxs, q_r)
    offset = 0.4;
    nFrames = size(q_r, 1);
    validIdxs = frame_idxs(frame_idxs >= 1 & frame_idxs <= nFrames);
    for idx = validIdxs(:)'
        plot([q_r(idx,1), q_r(idx,1) + offset * cos(q_r(idx,3))], ...
             [q_r(idx,2), q_r(idx,2) + offset * sin(q_r(idx,3))], ...
             '-', 'LineWidth', 1, 'Color', '#000000', 'HandleVisibility', 'off');
    end
end

function plotRobotVelocity(frame_idxs, q_r, v_r)
    scale = 10.0;
    nFrames = min(size(q_r, 1), size(v_r, 1));
    validIdxs = frame_idxs(frame_idxs >= 1 & frame_idxs <= nFrames);
    for idx = validIdxs(:)'
        plot([q_r(idx,1), q_r(idx,1) + scale * v_r(idx,1)], ...
             [q_r(idx,2), q_r(idx,2) + scale * v_r(idx,2)], ...
             '-', 'LineWidth', 1, 'Color', '#0000FF', 'HandleVisibility', 'off');
    end
end
