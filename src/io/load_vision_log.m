%% load_vision_log
% mcap / json / csv 形式のログを読み込み、Vision・Referee情報を構造体に整形する関数
%
% 引数:
%   inputFile       : 入力ファイル名またはパス (.mcap, .json, .csv 対応)
%   Opts.Topics     : mcap抽出対象のトピックcell配列 (デフォルト {'vision','referee'})
%   Opts.CsvSubDir  : CSV保存先のサブフォルダ (デフォルト "from_foxglove")
%   Opts.CsvTag     : CSVファイル名の先頭タグ (デフォルト "foxglove_data_")
function logData = load_vision_log(inputFile, Opts)
    arguments
        inputFile      (1,1) string
        Opts.Topics    cell         = {'vision', 'referee'}
        Opts.CsvSubDir (1,1) string = "from_foxglove"
        Opts.CsvTag    (1,1) string = "foxglove_data_"
    end

    paths = Constants.FileParam();
    [inDir, ~, ext] = fileparts(inputFile);
    extLower = lower(ext);
    robotIds = struct();

    % 1. 拡張子に応じてCSVまでの変換を実行
    switch extLower
        case ".mcap"
            jsonFile = convert_mcap2json(inputFile, paths.DataJsonDir, Opts.Topics);
            csvDir   = fullfile(paths.DataCsvDir, Opts.CsvSubDir);
            [csvFile, robotIds] = convert_json2csv(jsonFile, csvDir, Opts.CsvTag);

        case ".json"
            if inDir == ""
                jsonFile = fullfile(paths.DataJsonDir, inputFile);
            else
                jsonFile = inputFile;
            end
            csvDir = fullfile(paths.DataCsvDir, Opts.CsvSubDir);
            [csvFile, robotIds] = convert_json2csv(jsonFile, csvDir, Opts.CsvTag);

        case ".csv"
            if inDir == ""
                csvFile = fullfile(paths.DataCsvDir, Opts.CsvSubDir, inputFile);
            else
                csvFile = inputFile;
            end
            if ~isfile(csvFile)
                error('CSVファイルが見つかりません:\n%s', csvFile);
            end

        otherwise
            error('未対応のファイル形式です: %s (.mcap, .json, .csv のいずれかを指定してください)', ext);
    end

    % 2. CSVテーブル読み込み
    T = readtable(csvFile);
    if isempty(fieldnames(robotIds))
        robotIds = detect_robot_ids_from_table(T);
    end

    % 3. Visionデータの抽出 (index.BallIdx / index.RobotIdx に完全準拠)
    if ismember('topic', T.Properties.VariableNames)
        vision_data = T(strcmp(string(T.topic(:)), '/vision'), :);
    else
        vision_data = T;
    end
    nVis = height(vision_data);

    seqCol = get_num_col(vision_data, 'sequence', nVis);

    % BallIdx: [1:seq, 2:x, 3:y, 4:vx, 5:vy, 6:speed, 7:conf]
    ball = [ ...
        seqCol, ...
        get_num_col(vision_data, 'ball_x', nVis), ...
        get_num_col(vision_data, 'ball_y', nVis), ...
        get_num_col(vision_data, 'ball_vx', nVis), ...
        get_num_col(vision_data, 'ball_vy', nVis), ...
        get_num_col(vision_data, 'ball_speed', nVis), ...
        NaN(nVis, 1) ...
    ];

    raw_ball = [ ...
        seqCol, ...
        get_num_col(vision_data, 'rawBall_x', nVis), ...
        get_num_col(vision_data, 'rawBall_y', nVis), ...
        get_num_col(vision_data, 'rawBall_vx', nVis), ...
        get_num_col(vision_data, 'rawBall_vy', nVis), ...
        get_num_col(vision_data, 'rawBall_speed', nVis), ...
        get_num_col(vision_data, 'rawBall_confidence', nVis) ...
    ];

    % RobotIdx: [1:seq, 2:id, 3:x, 4:y, 5:angle, 6:vx, 7:vy, 8:speed, 9:conf]
    blue_robot       = build_robot_tensor(vision_data, seqCol, robotIds, 'blueRobotIds', 'blueRobot', false);
    raw_blue_robot   = build_robot_tensor(vision_data, seqCol, robotIds, 'rawBlueRobotIds', 'rawBlueRobot', true);
    yellow_robot     = build_robot_tensor(vision_data, seqCol, robotIds, 'yellowRobotIds', 'yellowRobot', false);
    raw_yellow_robot = build_robot_tensor(vision_data, seqCol, robotIds, 'rawYellowRobotIds', 'rawYellowRobot', true);

    % 4. Referee信号の抽出 (index.RefInfoIdx: [1:seq, 2:cmd, 3:stage, 4:state])
    if ismember('topic', T.Properties.VariableNames)
        referee_data = T(strcmp(string(T.topic(:)), '/referee'), :);
    else
        referee_data = table();
    end
    nRef = height(referee_data);
    if nRef > 0
        ref_info = [ ...
            string(get_num_col(referee_data, 'sequence', nRef)), ...
            get_str_col(referee_data, 'command', nRef), ...
            get_str_col(referee_data, 'stage', nRef), ...
            get_str_col(referee_data, 'state', nRef) ...
        ];
    else
        ref_info = strings(0, 4);
    end

    % 5. 構造体にまとめて返却
    logData = struct();
    logData.inputFile        = inputFile;
    logData.csvFile          = string(csvFile);
    logData.table            = T;
    logData.robotIds         = robotIds;
    logData.ball             = ball;
    logData.raw_ball         = raw_ball;
    logData.blue_robot       = blue_robot;
    logData.raw_blue_robot   = raw_blue_robot;
    logData.yellow_robot     = yellow_robot;
    logData.raw_yellow_robot = raw_yellow_robot;
    logData.ref_info         = ref_info;
end

%% ローカルヘルパー関数群

function col = get_num_col(T, colName, nRows)
    if ismember(colName, T.Properties.VariableNames)
        raw = T.(colName);
        if isnumeric(raw)
            col = double(raw(:));
        else
            col = str2double(string(raw(:)));
        end
    else
        col = NaN(nRows, 1);
    end
end

function col = get_str_col(T, colName, nRows)
    if ismember(colName, T.Properties.VariableNames)
        col = string(T.(colName)(:));
    else
        col = strings(nRows, 1);
    end
end

function tensor = build_robot_tensor(vision_data, seqCol, robotIds, idField, prefix, isRaw)
    tensor = [];
    if ~isfield(robotIds, idField) || isempty(robotIds.(idField))
        return;
    end
    ids = robotIds.(idField);
    nVis = numel(seqCol);
    tensor = NaN(nVis, 9, numel(ids));

    for i = 1:numel(ids)
        id = ids(i);
        if isRaw
            confCol = get_num_col(vision_data, sprintf('%s_%d_confidence', prefix, id), nVis);
        else
            confCol = NaN(nVis, 1);
        end
        tensor(:, :, i) = [ ...
            seqCol, ...
            get_num_col(vision_data, sprintf('%s_%d_id', prefix, id), nVis), ...
            get_num_col(vision_data, sprintf('%s_%d_x', prefix, id), nVis), ...
            get_num_col(vision_data, sprintf('%s_%d_y', prefix, id), nVis), ...
            get_num_col(vision_data, sprintf('%s_%d_angle', prefix, id), nVis), ...
            get_num_col(vision_data, sprintf('%s_%d_vx', prefix, id), nVis), ...
            get_num_col(vision_data, sprintf('%s_%d_vy', prefix, id), nVis), ...
            get_num_col(vision_data, sprintf('%s_%d_speed', prefix, id), nVis), ...
            confCol ...
        ];
    end
end

function robotIds = detect_robot_ids_from_table(T)
    robotIds = struct();
    varNames = T.Properties.VariableNames;
    specs = {
        'blueRobotIds',      '^blueRobot_(\d+)_id$';
        'rawBlueRobotIds',   '^rawBlueRobot_(\d+)_id$';
        'yellowRobotIds',    '^yellowRobot_(\d+)_id$';
        'rawYellowRobotIds', '^rawYellowRobot_(\d+)_id$'
    };
    for s = 1:size(specs, 1)
        field = specs{s, 1};
        pat   = specs{s, 2};
        ids = [];
        for v = 1:numel(varNames)
            tok = regexp(varNames{v}, pat, 'tokens', 'once');
            if ~isempty(tok)
                ids(end+1) = str2double(tok{1}); %#ok<AGROW>
            end
        end
        if ~isempty(ids)
            robotIds.(field) = unique(ids, 'stable');
        end
    end
end
