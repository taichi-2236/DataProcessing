%% convert_json2csv
% JSONファイル（JSON Lines形式）をCSVに変換する関数
%
% 引数:
%   jsonFilePath : 変換元のJSONファイルパス
%   outputDir    : 出力先のディレクトリ（省略時は data/csv/from_foxglove）
%   tag          : 出力ファイル名の先頭につけるタグ（省略時は ''）
function [outputFilePath, robotIds] = convert_json2csv(jsonFilePath, outputDir, tag)
    arguments
        jsonFilePath (1,1) string
        outputDir    (1,1) string = ""
        tag          (1,1) string = ""
    end

    paths = Constants.FileParam();
    if ~contains(jsonFilePath, "\") && ~contains(jsonFilePath, "/")
        jsonFilePath = fullfile(paths.DataJsonDir, jsonFilePath);
    end

    fid = fopen(jsonFilePath, 'r', 'n', 'UTF-8');
    if fid == -1
        error('JSONファイルを開くことができませんでした: %s', jsonFilePath);
    end
    cleanupObj = onCleanup(@() fclose(fid));

    if outputDir == ""
        outputDir = fullfile(paths.DataCsvDir, "from_foxglove");
    elseif ~java.io.File(outputDir).isAbsolute()
        outputDir = fullfile(paths.MainFolderPath, outputDir);
    end
    if ~isfolder(outputDir)
        mkdir(outputDir);
    end

    [~, name, ~] = fileparts(jsonFilePath);
    outputFilePath = string(fullfile(outputDir, append(tag, name, ".csv")));

    disp('Convert : json >>> csv ...');

    blueIdsAll      = [];
    rawBlueIdsAll   = [];
    yellowIdsAll    = [];
    rawYellowIdsAll = [];

    rows = {};
    lineNum = 0;

    while ~feof(fid)
        lineStr = fgetl(fid);
        if ~ischar(lineStr) || isempty(strtrim(lineStr))
            continue;
        end

        lineNum = lineNum + 1;
        try
            item = jsondecode(lineStr);
        catch ME
            warning('行 %d の解析に失敗したためスキップします: %s', lineNum, ME.message);
            continue;
        end

        row = struct();

        % メタデータ
        row.topic        = string(getfield_safe(item, 'topic', ''));
        row.sequence     = getfield_safe(item, 'sequence', NaN);
        row.log_time     = getfield_safe(item, 'log_time', NaN);
        row.publish_time = getfield_safe(item, 'publish_time', NaN);

        % data フィールド
        d = getfield_safe(item, 'data', struct());

        % --- AutoRef / GameController の情報 ---
        if row.topic == "/referee" || isfield(d, 'stage') || isfield(d, 'command')
            row.stage   = string(getfield_safe(d, 'stage', ''));
            row.state   = string(getfield_safe(d, 'state', ''));
            row.command = string(getfield_safe(d, 'command', ''));

            yellow = getfield_safe(d, 'yellow', struct());
            row.yellow_name           = string(getfield_safe(yellow, 'name', ''));
            row.yellow_score          = getfield_safe(yellow, 'score', NaN);
            row.yellow_maxAllowedBots = getfield_safe(yellow, 'maxAllowBots', NaN);
            row.yellow_yellowCards    = getfield_safe(yellow, 'yellowCards', NaN);
            row.yellow_yellowCardTime = getfield_safe(yellow, 'yellowCardTime', NaN);
            row.yellow_redCards       = getfield_safe(yellow, 'redCards', NaN);
            row.yellow_timeouts       = getfield_safe(yellow, 'timeouts', NaN);
            row.yellow_timeoutTime    = getfield_safe(yellow, 'timeoutTime', NaN);
            row.yellow_foulCounter    = getfield_safe(yellow, 'foulCounter', NaN);
            row.yellow_canPlaceBall   = string(getfield_safe(yellow, 'canPlaceBall', ''));
            row.yellow_typeOfFouls    = string(getfield_safe(yellow, 'typeOfFouls', ''));

            blue = getfield_safe(d, 'blue', struct());
            row.blue_name           = string(getfield_safe(blue, 'name', ''));
            row.blue_score          = getfield_safe(blue, 'score', NaN);
            row.blue_maxAllowedBots = getfield_safe(blue, 'maxAllowBots', NaN);
            row.blue_blueCards      = getfield_safe(blue, 'blueCards', NaN);
            row.blue_blueCardTime   = getfield_safe(blue, 'blueCardTime', NaN);
            row.blue_redCards       = getfield_safe(blue, 'redCards', NaN);
            row.blue_timeouts       = getfield_safe(blue, 'timeouts', NaN);
            row.blue_timeoutTime    = getfield_safe(blue, 'timeoutTime', NaN);
            row.blue_foulCounter    = getfield_safe(blue, 'foulCounter', NaN);
            row.blue_canPlaceBall   = string(getfield_safe(blue, 'canPlaceBall', ''));
            row.blue_typeOfFouls    = string(getfield_safe(blue, 'typeOfFouls', ''));
        end

        % --- フィルタ済みボール情報 (ball) ---
        ball     = getfield_safe(d, 'ball', struct());
        ball_loc = getfield_safe(ball, 'loc', struct());
        ball_vel = getfield_safe(ball, 'vel', struct());
        row.ball_x     = getfield_safe(ball_loc, 'x', NaN);
        row.ball_y     = getfield_safe(ball_loc, 'y', NaN);
        row.ball_vx    = getfield_safe(ball_vel, 'x', NaN);
        row.ball_vy    = getfield_safe(ball_vel, 'y', NaN);
        row.ball_speed = getfield_safe(ball, 'speed', NaN);

        % --- Rawボール情報 (rawBall) ---
        rawBall = getfield_safe(d, 'rawBall', struct());
        rawLoc  = getfield_safe(rawBall, 'rawLoc', struct());
        rawVel  = getfield_safe(rawBall, 'rawVel', struct());
        row.rawBall_x          = getfield_safe(rawLoc, 'x', NaN);
        row.rawBall_y          = getfield_safe(rawLoc, 'y', NaN);
        row.rawBall_vx         = getfield_safe(rawVel, 'x', NaN);
        row.rawBall_vy         = getfield_safe(rawVel, 'y', NaN);
        row.rawBall_speed      = getfield_safe(rawBall, 'rawSpeed', NaN);
        row.rawBall_confidence = getfield_safe(rawBall, 'confidence', NaN);

        % --- 各チームロボット情報（全フレームでのユニークIDを蓄積） ---
        [row, ids] = extract_robots(row, d, 'blueRobots', 'blueRobot', false);
        blueIdsAll = unique([blueIdsAll, ids], 'stable');

        [row, ids] = extract_robots(row, d, 'rawBlueRobots', 'rawBlueRobot', true);
        rawBlueIdsAll = unique([rawBlueIdsAll, ids], 'stable');

        [row, ids] = extract_robots(row, d, 'yellowRobots', 'yellowRobot', false);
        yellowIdsAll = unique([yellowIdsAll, ids], 'stable');

        [row, ids] = extract_robots(row, d, 'rawYellowRobots', 'rawYellowRobot', true);
        rawYellowIdsAll = unique([rawYellowIdsAll, ids], 'stable');

        rows{end+1} = row; %#ok<AGROW>
    end

    robotIds = struct();
    if ~isempty(blueIdsAll)
        robotIds.blueRobotIds = blueIdsAll;
    end
    if ~isempty(rawBlueIdsAll)
        robotIds.rawBlueRobotIds = rawBlueIdsAll;
    end
    if ~isempty(yellowIdsAll)
        robotIds.yellowRobotIds = yellowIdsAll;
    end
    if ~isempty(rawYellowIdsAll)
        robotIds.rawYellowRobotIds = rawYellowIdsAll;
    end

    if isempty(rows)
        warning('変換可能な有効なデータが見つかりませんでした。');
        return;
    end

    T = struct2table_fill(rows);
    writetable(T, outputFilePath);
    fprintf('変換が完了しました: %s (全 %d 行)\n', outputFilePath, height(T));
end

%% ローカルヘルパー関数群

function [row, ids] = extract_robots(row, d, fieldName, prefix, isRaw)
    ids = [];
    if ~isfield(d, fieldName) || isempty(d.(fieldName)) || ~isstruct(d.(fieldName))
        return;
    end

    robots = d.(fieldName);
    if isRaw
        idField    = 'rawRobotId';
        locField   = 'rawLoc';
        velField   = 'rawVel';
        angleField = 'rawAngle';
        speedField = 'rawSpeed';
    else
        idField    = 'robotId';
        locField   = 'loc';
        velField   = 'vel';
        angleField = 'angle';
        speedField = 'speed';
    end

    for k = 1:numel(robots)
        r = robots(k);
        if ~isfield(r, idField) || isempty(r.(idField))
            continue;
        end
        id = double(r.(idField));
        ids(end+1) = id; %#ok<AGROW>

        rLoc = getfield_safe(r, locField, struct());
        rVel = getfield_safe(r, velField, struct());

        row.(sprintf('%s_%d_id', prefix, id))    = id;
        row.(sprintf('%s_%d_x', prefix, id))     = getfield_safe(rLoc, 'x', NaN);
        row.(sprintf('%s_%d_y', prefix, id))     = getfield_safe(rLoc, 'y', NaN);
        row.(sprintf('%s_%d_vx', prefix, id))    = getfield_safe(rVel, 'x', NaN);
        row.(sprintf('%s_%d_vy', prefix, id))    = getfield_safe(rVel, 'y', NaN);
        row.(sprintf('%s_%d_angle', prefix, id)) = getfield_safe(r, angleField, NaN);
        row.(sprintf('%s_%d_speed', prefix, id)) = getfield_safe(r, speedField, NaN);
        if isRaw
            row.(sprintf('%s_%d_confidence', prefix, id)) = getfield_safe(r, 'confidence', NaN);
        end
    end
end

function val = getfield_safe(s, field, defaultVal)
    if isstruct(s) && isfield(s, field) && ~isempty(s.(field)) && ~isstruct(s.(field))
        val = s.(field);
    elseif isstruct(s) && isfield(s, field) && isstruct(s.(field))
        val = s.(field);
    else
        val = defaultVal;
    end
end

function T = struct2table_fill(rowsCell)
    allFields = {};
    for i = 1:numel(rowsCell)
        allFields = unique([allFields, fieldnames(rowsCell{i})'], 'stable');
    end

    n = numel(rowsCell);
    flatStruct = struct();

    for j = 1:numel(allFields)
        fname = allFields{j};
        sampleVal = NaN;
        for i = 1:n
            if isfield(rowsCell{i}, fname) && ~isempty(rowsCell{i}.(fname))
                sampleVal = rowsCell{i}.(fname);
                break;
            end
        end

        if isstring(sampleVal) || ischar(sampleVal)
            colData = strings(n, 1);
            for i = 1:n
                if isfield(rowsCell{i}, fname)
                    colData(i) = string(rowsCell{i}.(fname));
                else
                    colData(i) = "";
                end
            end
        else
            colData = NaN(n, 1);
            for i = 1:n
                if isfield(rowsCell{i}, fname) && isnumeric(rowsCell{i}.(fname))
                    colData(i) = double(rowsCell{i}.(fname));
                end
            end
        end
        flatStruct.(fname) = colData;
    end
    T = struct2table(flatStruct);
end
