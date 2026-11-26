%% plot_err_traj2ball
% 目標経路とボールとの誤差の時間変化を描画・保存する関数
%
% 引数:
%   timeSec   : 時間ベクトル [s] (例: (1:N)/60)
%   errSeries : 誤差データ [N x M] (列ごとに1系列、単一系列も複数手法比較も可)
%   Opts      : ラベル・色・出力先などの描画オプション
function fig = plot_err_traj2ball(timeSec, errSeries, Opts)
    arguments
        timeSec   double
        errSeries double
        Opts.Labels      string        = ["Measured error"]
        Opts.Colors      string        = ["#0000ff", "#ff0000", "#007f00"]
        Opts.YLim        double        = [-0.15, 0.06]
        Opts.FontSize    (1,1) double  = 28
        Opts.DataFile    (1,1) string  = ""
        Opts.OutputTag   (1,1) string  = "errTraj2Ball_"
        Opts.OutputFile  (1,1) string  = ""
        Opts.SaveFigure  (1,1) logical = true
        Opts.CropFigure  (1,1) logical = true
    end

    timeSec = timeSec(:);
    if isvector(errSeries)
        errSeries = errSeries(:);
    end
    nCols = size(errSeries, 2);

    fig = figure;
    grid on;
    hold on;

    plot([min(timeSec), max(timeSec)], [0.0, 0.0], '--', 'LineWidth', 1, 'Color', '#080808');

    for c = 1:nCols
        colorIdx = mod(c - 1, numel(Opts.Colors)) + 1;
        plot(timeSec, errSeries(:, c), '-', 'LineWidth', 2, 'Color', Opts.Colors(colorIdx));
    end

    xlabel("time (s)");
    ylabel("error (m)");
    if numel(Opts.YLim) == 2
        ylim(Opts.YLim);
    end

    legendLabels = ["reference path for ball", Opts.Labels(1:min(numel(Opts.Labels), nCols))];
    legend(legendLabels, 'Location', 'northwest');
    hold off;

    set(gca, 'FontSize', Opts.FontSize);
    set(gcf, 'PaperOrientation', 'landscape');

    if Opts.SaveFigure
        if Opts.OutputFile ~= ""
            outDir = fileparts(Opts.OutputFile);
            if outDir ~= "" && ~isfolder(outDir)
                mkdir(outDir);
            end
            if Opts.CropFigure
                exportgraphics(gca, Opts.OutputFile);
            else
                print(Opts.OutputFile, '-dpdf', '-fillpage');
            end
            disp("PlotOut : " + Opts.OutputFile);
        elseif Opts.DataFile ~= ""
            output_figure(Opts.DataFile, "", Opts.OutputTag, Opts.CropFigure);
        end
    end
end
