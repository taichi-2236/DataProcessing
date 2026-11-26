%% render_anim
% ロボットとボールの軌跡アニメーション動画 (.avi) を生成・保存する関数
%
% 引数:
%   tout : フレーム番号または時刻ベクトル
%   q_r  : ロボット姿勢時系列 [N x 3] (x [m], y [m], angle [rad])
%   q_b  : ボール位置時系列   [N x 2] (x [m], y [m])
%   Opts : 動画出力オプション
function moviePath = render_anim(tout, q_r, q_b, Opts)
    arguments
        tout double
        q_r  double
        q_b  double
        Opts.DataFile    (1,1) string = "animation"
        Opts.OutputDir   (1,1) string = ""
        Opts.FrameStep   (1,1) double = 5
        Opts.FrameRate   (1,1) double = 10
        Opts.ResizeScale (1,1) double = 4
    end

    if Opts.OutputDir == ""
        outDir = Constants.FileParam().OutputMovieDir;
    else
        outDir = Opts.OutputDir;
    end
    if ~isfolder(outDir)
        mkdir(outDir);
    end

    [~, name, ~] = fileparts(Opts.DataFile);
    cleanName = regexprep(name, "^\w*_data_", "");
    moviePath = string(fullfile(outDir, append("anim_", cleanName, ".avi")));

    fig = figure('Units', 'pixels', 'Position', [100, 500, 800, 600]);
    vobj = VideoWriter(moviePath);
    vobj.Quality   = 100;
    vobj.FrameRate = Opts.FrameRate;
    open(vobj);
    cleanupVideo = onCleanup(@() close(vobj));

    d_rf = 0.078;
    w_d  = 0.075;

    xRange = [min(q_r(:,1)) - 0.2, max(q_r(:,1)) + 0.2];
    yRange = [min(q_r(:,2)) - 0.2, max(q_r(:,2)) + 0.2];

    for k = 1:Opts.FrameStep:numel(tout)
        plot([-4.5, 1.5], [-2.0, -2.0], 'r-');
        hold on;
        grid on;

        % ロボット描画
        plot(q_r(k,1), q_r(k,2), 'ro');
        sslrobot(q_r(k,1), q_r(k,2), q_r(k,3));
        plot([q_r(k,1), q_r(k,1) + d_rf * cos(q_r(k,3))], ...
             [q_r(k,2), q_r(k,2) + d_rf * sin(q_r(k,3))], 'r-');
        plot([q_r(k,1) + d_rf * cos(q_r(k,3)) + 0.5 * w_d * cos(q_r(k,3) + pi/2), ...
              q_r(k,1) + d_rf * cos(q_r(k,3)) + 0.5 * w_d * cos(q_r(k,3) - pi/2)], ...
             [q_r(k,2) + d_rf * sin(q_r(k,3)) + 0.5 * w_d * sin(q_r(k,3) + pi/2), ...
              q_r(k,2) + d_rf * sin(q_r(k,3)) + 0.5 * w_d * sin(q_r(k,3) - pi/2)], 'r-');

        % ボール描画
        obj_b = plot(q_b(k,1), q_b(k,2), 'Marker', 'o', ...
            'MarkerFaceColor', '#FF8F00', 'MarkerEdgeColor', '#000000');
        obj_b.MarkerSize = 4.0;

        axis equal;
        xlim(xRange);
        ylim(yRange);

        % 軌跡描画
        plot(q_r(1:k,1), q_r(1:k,2), '-', 'LineWidth', 2, 'Color', '#007FFF');
        plot(q_b(1:k,1), q_b(1:k,2), '-', 'LineWidth', 2, 'Color', '#FF8F00');

        title(sprintf('frame = %5.1f', tout(k)));
        xlabel('X (m)');
        ylabel('Y (m)');
        set(gca, 'FontSize', 16);
        hold off;

        drawnow limitrate;
        frame = getframe(fig);
        f = imresize(frame.cdata, Opts.ResizeScale);
        writeVideo(vobj, f);
    end

    close(fig);
    disp("MovieOut : " + moviePath);
end
