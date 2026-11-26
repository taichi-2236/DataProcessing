%% plot_field
% RoboCup SSL フィールドを描画する関数（引数なし呼び出しでも従来通り動作）
function plot_field(Opts)
    arguments
        Opts.Division    (1,1) string = "B"
        Opts.DisplayMode (1,1) string = "normal"
        Opts.Margin      (1,1) string = "ON"
        Opts.Axes                     = []
    end

    if isempty(Opts.Axes)
        ax = gca;
    else
        ax = Opts.Axes;
    end

    % Divisionによって線の長さを変える
    switch upper(Opts.Division)
        case "A"
            FieldLength     = 12.0;
            FieldWidth      =  9.0;
            CircleRadius    =  0.5;
            DefenseAreaLine =  1.8;
        otherwise
            FieldLength     =  9.0;
            FieldWidth      =  6.0;
            CircleRadius    =  0.5;
            DefenseAreaLine =  1.0;
    end

    % 指定されたモードによってフィールドの見た目を変える
    switch lower(Opts.DisplayMode)
        case "mono"
            LineColor  = '#9F9F9F';
            FieldColor = '#FFFFFF';
        otherwise
            LineColor  = '#FFFFFF';
            FieldColor = '#007F00';
    end

    % 表示されるフィールドの周りのマージンを調整する
    switch upper(Opts.Margin)
        case "ON"
            FieldLengthMargin = 0.5;
            FieldWidthMargin  = 0.5;
        otherwise
            FieldLengthMargin = 0;
            FieldWidthMargin  = 0;
    end

    FieldLengthH = FieldLength / 2.0;
    FieldWidthH  = FieldWidth / 2.0;

    wasHeld = ishold(ax);
    hold(ax, 'on');

    % 背景
    xregion(ax, -FieldLengthH - CircleRadius, FieldLengthH + CircleRadius, ...
        "FaceColor", FieldColor, 'HandleVisibility', 'off');

    % 外枠・センターライン・ディフェンスエリア
    lines = {
        [ FieldLengthH,  FieldLengthH], [-FieldWidthH,  FieldWidthH];
        [-FieldLengthH, -FieldLengthH], [-FieldWidthH,  FieldWidthH];
        [-FieldLengthH,  FieldLengthH], [ FieldWidthH,  FieldWidthH];
        [-FieldLengthH,  FieldLengthH], [-FieldWidthH, -FieldWidthH];
        [ 0.0,           0.0         ], [-FieldWidthH,  FieldWidthH];
        [-FieldLengthH,  FieldLengthH], [ 0.0,          0.0        ];
        [-FieldLengthH, -(FieldLengthH - DefenseAreaLine)], [ DefenseAreaLine,  DefenseAreaLine];
        [-FieldLengthH, -(FieldLengthH - DefenseAreaLine)], [-DefenseAreaLine, -DefenseAreaLine];
        [-(FieldLengthH - DefenseAreaLine), -(FieldLengthH - DefenseAreaLine)], [-DefenseAreaLine, DefenseAreaLine];
        [ (FieldLengthH - DefenseAreaLine),  FieldLengthH], [ DefenseAreaLine,  DefenseAreaLine];
        [ (FieldLengthH - DefenseAreaLine),  FieldLengthH], [-DefenseAreaLine, -DefenseAreaLine];
        [ (FieldLengthH - DefenseAreaLine),  (FieldLengthH - DefenseAreaLine)], [-DefenseAreaLine, DefenseAreaLine]
    };
    for i = 1:size(lines, 1)
        plot(ax, lines{i, 1}, lines{i, 2}, ...
            '-', 'LineWidth', 1, 'Color', LineColor, 'HandleVisibility', 'off');
    end

    % センターサークル
    theta = linspace(0, 2*pi, 100);
    plot(ax, CircleRadius * cos(theta), CircleRadius * sin(theta), ...
        '-', 'LineWidth', 1, 'Color', LineColor, 'HandleVisibility', 'off');

    axis(ax, 'equal');
    grid(ax, 'on');
    xlim(ax, [-(FieldLengthH + FieldLengthMargin), (FieldLengthH + FieldLengthMargin)]);
    ylim(ax, [-(FieldWidthH + FieldWidthMargin),   (FieldWidthH + FieldWidthMargin)]);
    xticks(ax, [-FieldLengthH, fix(-FieldLengthH + eps(10)):1.0:fix(FieldLengthH - eps(10)), FieldLengthH]);
    yticks(ax, [-FieldWidthH,  fix(-FieldWidthH + eps(10)):1.0:fix(FieldWidthH - eps(10)),   FieldWidthH]);

    if ~wasHeld
        hold(ax, 'off');
    end
end
