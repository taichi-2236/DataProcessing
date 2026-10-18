%% convert_json2csv
% jsonファイル(json Lines形式)をCSVに変換する関数

%%% 1. 引数
% * *jsonFilePath* 変換元のjsonファイル（この関数からアクセスできるパス）
% * *dir* 出力先のディレクトリ
% * *tag* 出力ファイルの先頭につけるタグ
function [outputFilePath, robotIds] = convert_json2csv(jsonFilePath,dir,tag)
    % ファイルオープン
    fid     = fopen(jsonFilePath, 'r', 'n', 'UTF-8');
    fid_tmp = fopen(jsonFilePath, 'r', 'n', 'UTF-8');
    if fid == -1
        error('ファイルを開くことができませんでした: %s', jsonFilePath);
    end
    
    if nargin < 2 || isempty(dir)
        dir = '';
    end
    if nargin < 3 || isempty(tag)
        tag = '';
    end
    
    % 出力ファイルを指定
    [~,name,~] = fileparts(jsonFilePath);
    outputFilePath = append(dir,tag,name,".csv");
    
    disp('Convert : json >>> csv ...');
    
    robotIds = struct();
    
    rows = {};
    lineNum = 0;
    
    % topicsの種類を格納
    sequence_check = 1;
    topics = [];
    while sequence_check < 2
        lineStr = fgetl(fid_tmp);
        if ~ischar(lineStr) || isempty(strtrim(lineStr))
            continue;
        end
        try
            item = jsondecode(lineStr);
        catch ME
            warning('行 %d の解析に失敗したためスキップします: %s', lineNum, ME.message);
            continue;
        end
        sequence_check = getfield_safe(item,'sequence',NaN);
        if sequence_check > 1
            break;
        end
        topics = [topics,string(getfield_safe(item,'topic',''))];
    end
    fclose(fid_tmp);
    
    % tppicsごとにデータを格納
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
        row.topic = string(getfield_safe(item,'topic',''));
        row.sequence = getfield_safe(item,'sequence',NaN);
        row.log_time = getfield_safe(item,'log_time',NaN);
        row.publish_time = getfield_safe(item,'publish_time',NaN);
    
        % data フィールド
        d = getfield_safe(item,'data',struct());
    
        % --- AutoRef,GameControlerの情報 ---
        if max(contains(topics,'/referee')) == 1
            row.stage = string(getfield_safe(d,'stage',''));
            row.state = string(getfield_safe(d,'state',''));
            row.command = string(getfield_safe(d,'command',''));
    
            yellow = getfield_safe(d,'yellow',struct());
            row.yellow_name           = string(getfield_safe(yellow,'name',''));
            row.yellow_score          = getfield_safe(yellow,'score',NaN);
            row.yellow_maxAllowedBots = getfield_safe(yellow,'maxAllowBots',NaN);
            row.yellow_yellowCards    = getfield_safe(yellow,'yellowCards',NaN);
            row.yellow_yellowCardTime = getfield_safe(yellow,'yellowCardTime',NaN);
            row.yellow_redCards       = getfield_safe(yellow,'redCards',NaN);
            row.yellow_timeouts       = getfield_safe(yellow,'timeouts',NaN);
            row.yellow_timeoutTime    = getfield_safe(yellow,'timeoutTime',NaN);
            row.yellow_foulCounter    = getfield_safe(yellow,'foulCounter',NaN);
            row.yellow_canPlaceBall   = string(getfield_safe(yellow,'canPlaceBall',''));
            row.yellow_typeOfFouls    = string(getfield_safe(yellow,'typeOfFouls',''));
    
            blue = getfield_safe(d,'blue',struct());
            row.blue_name           = string(getfield_safe(blue,'name',''));
            row.blue_score          = getfield_safe(blue,'score',NaN);
            row.blue_maxAllowedBots = getfield_safe(blue,'maxAllowBots',NaN);
            row.blue_blueCards      = getfield_safe(blue,'blueCards',NaN);
            row.blue_blueCardTime   = getfield_safe(blue,'blueCardTime',NaN);
            row.blue_redCards       = getfield_safe(blue,'redCards',NaN);
            row.blue_timeouts       = getfield_safe(blue,'timeouts',NaN);
            row.blue_timeoutTime    = getfield_safe(blue,'timeoutTime',NaN);
            row.blue_foulCounter    = getfield_safe(blue,'foulCounter',NaN);
            row.blue_canPlaceBall   = string(getfield_safe(blue,'canPlaceBall',''));
            row.blue_typeOfFouls    = string(getfield_safe(blue,'typeOfFouls',''));
        end
    
        % --- フィルタ済みボール情報 (ball) ---
        ball = getfield_safe(d,'ball',struct());
        ball_loc = getfield_safe(ball,'loc',struct());
        ball_vel = getfield_safe(ball,'vel',struct());
        row.ball_x = getfield_safe(ball_loc,'x',NaN);
        row.ball_y = getfield_safe(ball_loc,'y',NaN);
        row.ball_vx = getfield_safe(ball_vel,'x',NaN);
        row.ball_vy = getfield_safe(ball_vel,'y',NaN);
        row.ball_speed = getfield_safe(ball,'speed',NaN);
    
        % --- Rawボール情報 (rawBall) ---
        rawBall = getfield_safe(d,'rawBall',struct());
        rawLoc = getfield_safe(rawBall,'rawLoc',struct());
        rawVel = getfield_safe(rawBall,'rawVel',struct());
        row.rawBall_x = getfield_safe(rawLoc,'x',NaN);
        row.rawBall_y = getfield_safe(rawLoc,'y',NaN);
        row.rawBall_vx = getfield_safe(rawVel,'x',NaN);
        row.rawBall_vy = getfield_safe(rawVel,'y',NaN);
        row.rawBall_speed = getfield_safe(rawBall,'rawSpeed',NaN);
        row.rawBall_confidence = getfield_safe(rawBall,'confidence',NaN);
    
        % --- Blueロボット情報 (blueRobots) ---
        if isfield(d,'blueRobots') && ~isempty(d.blueRobots) && isstruct(d.blueRobots)
            blueRobots = d.blueRobots;
            blueRobotIds = -1 * ones(1,numel(blueRobots));
            for k = 1:numel(blueRobots)
                r = blueRobots(k);
                if ~isfield(r, 'robotId')
                    continue;
                end
                id = r.robotId;
                blueRobotIds(k) = id;
                r_loc = getfield_safe(r,'loc',struct());
                r_vel = getfield_safe(r,'vel',struct());
                
                row.(sprintf('blueRobot_%d_id',id))    = id;
                row.(sprintf('blueRobot_%d_x',id))     = getfield_safe(r_loc,'x',NaN);
                row.(sprintf('blueRobot_%d_y',id))     = getfield_safe(r_loc,'y',NaN);
                row.(sprintf('blueRobot_%d_vx',id))    = getfield_safe(r_vel,'x',NaN);
                row.(sprintf('blueRobot_%d_vy',id))    = getfield_safe(r_vel,'y',NaN);
                row.(sprintf('blueRobot_%d_angle',id)) = getfield_safe(r,'angle',NaN);
                row.(sprintf('blueRobot_%d_speed',id)) = getfield_safe(r,'speed',NaN);
            end
            robotIds.blueRobotIds = blueRobotIds;
        end
    
        % --- Blueロボットの生データ情報 (rawBlueRobots) ---
        if isfield(d,'rawBlueRobots') && ~isempty(d.rawBlueRobots) && isstruct(d.rawBlueRobots)
            rawBlueRobots = d.rawBlueRobots;
            rawBlueRobotIds = -1 * ones(1,numel(rawBlueRobots));
            for k = 1:numel(rawBlueRobots)
                r = rawBlueRobots(k);
                if ~isfield(r,'rawRobotId')
                    continue;
                end
                id = r.rawRobotId;
                rawBlueRobotIds(k) = id;
                rawLoc = getfield_safe(r, 'rawLoc', struct());
                rawVel = getfield_safe(r, 'rawVel', struct());
                
                row.(sprintf('rawBlueRobot_%d_id',id))         = id;
                row.(sprintf('rawBlueRobot_%d_x',id))          = getfield_safe(rawLoc,'x',NaN);
                row.(sprintf('rawBlueRobot_%d_y',id))          = getfield_safe(rawLoc,'y',NaN);
                row.(sprintf('rawBlueRobot_%d_vx',id))         = getfield_safe(rawVel,'x',NaN);
                row.(sprintf('rawBlueRobot_%d_vy',id))         = getfield_safe(rawVel,'y',NaN);
                row.(sprintf('rawBlueRobot_%d_angle',id))      = getfield_safe(r,'rawAngle',NaN);
                row.(sprintf('rawBlueRobot_%d_speed',id))      = getfield_safe(r,'rawSpeed',NaN);
                row.(sprintf('rawBlueRobot_%d_confidence',id)) = getfield_safe(r,'confidence',NaN);
            end
            robotIds.rawBlueRobotIds = rawBlueRobotIds;
        end
    
        % --- Yellowロボット情報 (yellowRobots) ---
        if isfield(d,'yellowRobots') && ~isempty(d.yellowRobots) && isstruct(d.yellowRobots)
            yellowRobots   = d.yellowRobots;
            yellowRobotIds = -1 * ones(1,numel(yellowRobots)); 
            for k = 1:numel(yellowRobots)
                r = yellowRobots(k);
                if ~isfield(r,'robotId')
                    continue;
                end
                id = r.robotId;
                yellowRobotIds(k) = id;
                r_loc = getfield_safe(r,'loc',struct());
                r_vel = getfield_safe(r,'vel',struct());
                
                row.(sprintf('yellowRobot_%d_id',id))    = id;
                row.(sprintf('yellowRobot_%d_x',id))     = getfield_safe(r_loc,'x',NaN);
                row.(sprintf('yellowRobot_%d_y',id))     = getfield_safe(r_loc,'y',NaN);
                row.(sprintf('yellowRobot_%d_vx',id))    = getfield_safe(r_vel,'x',NaN);
                row.(sprintf('yellowRobot_%d_vy',id))    = getfield_safe(r_vel,'y',NaN);
                row.(sprintf('yellowRobot_%d_angle',id)) = getfield_safe(r,'angle',NaN);
                row.(sprintf('yellowRobot_%d_speed',id)) = getfield_safe(r,'speed',NaN);
            end
            robotIds.yellowRobotIds = yellowRobotIds;
        end
    
        % --- Yellowロボットの生データ情報 (rawYellowRobots) ---
        if isfield(d,'rawYellowRobots') && ~isempty(d.rawYellowRobots) && isstruct(d.rawYellowRobots)
            rawYellowRobots = d.rawYellowRobots;
            rawYellowRobotIds = -1 * ones(1,numel(rawYellowRobots));
            for k = 1:numel(rawYellowRobots)
                r = rawYellowRobots(k);
                if ~isfield(r,'rawRobotId')
                    continue;
                end
                id = r.rawRobotId;
                rawYellowRobotIds(k) = id;
                rawLoc = getfield_safe(r,'rawLoc',struct());
                rawVel = getfield_safe(r,'rawVel',struct());
                
                row.(sprintf('rawYellowRobot_%d_id',id))         = id;
                row.(sprintf('rawYellowRobot_%d_x',id))          = getfield_safe(rawLoc,'x',NaN);
                row.(sprintf('rawYellowRobot_%d_y',id))          = getfield_safe(rawLoc,'y',NaN);
                row.(sprintf('rawYellowRobot_%d_vx',id))         = getfield_safe(rawVel,'x',NaN);
                row.(sprintf('rawYellowRobot_%d_vy',id))         = getfield_safe(rawVel,'y',NaN);
                row.(sprintf('rawYellowRobot_%d_angle',id))      = getfield_safe(r,'rawAngle',NaN);
                row.(sprintf('rawYellowRobot_%d_speed',id))      = getfield_safe(r,'rawSpeed',NaN);
                row.(sprintf('rawYellowRobot_%d_confidence',id)) = getfield_safe(r,'confidence',NaN);
            end
            robotIds.rawYellowRobotIds = rawYellowRobotIds;
        end
    
        rows{end+1} = row;
    end
    fclose(fid);
    
    % エラー処理
    if isempty(rows)
        warning('変換可能な有効なデータが見つかりませんでした。');
        return;
    end
    
    % 欠損列をNaN補填してテーブルに変換し出力
    T = struct2table_fill(rows);
    writetable(T, outputFilePath);
    fprintf('変換が完了しました: %s (全 %d 行)\n', outputFilePath, height(T));
end

%%% 2. ヘルパー関数: getfild_safe 
% 安全なフィールド取得（空オブジェクト{}対応）
function val = getfield_safe(s, field, defaultVal)
    if isstruct(s) && isfield(s, field) && ~isempty(s.(field)) && isstruct(s.(field)) == false
        val = s.(field);
    elseif isstruct(s) && isfield(s, field) && isstruct(s.(field))
        val = s.(field);
    else
        val = defaultVal;
    end
end

%%% 3. ヘルパー関数: struct2table_fill
% フィールド数が異なる構造体配列をTable化
function T = struct2table_fill(rowsCell)
    allFields = {};
    for i = 1:length(rowsCell)
        allFields = unique([allFields, fieldnames(rowsCell{i})'], 'stable');
    end

    n = length(rowsCell);
    flatStruct = struct();
    
    for j = 1:length(allFields)
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