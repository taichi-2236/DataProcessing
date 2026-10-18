%% convert_mcap2json
% mcapファイルをjsonファイル（json Lines形式）に変換する関数

%%% 1. 引数
% * *inputFileName* 変換元のmcapファイル名
% * *outputDir* 出力先のディレクトリ
% * *topics* mcapから抽出するtopicsを文字列で列挙したcell配列
function outputFilePath = convert_mcap2json(inputFileName,outputDir,topics)
    % ホームディレクトリの絶対パスを自動取得
    if ~exist("MainFolderPath","var")
        funcPath = mfilename('fullpath');      % この関数自身のフルパス
        [funcDir, ~, ~] = fileparts(funcPath); % 'function' フォルダのパス
        homeDir = fileparts(funcDir);          % さらに上のホームディレクトリのパス
    else
        homeDir = MainFolderPath;
    end

    % mcapスクリプトの絶対パスを構築
    scriptPath = fullfile(homeDir, '+Tools', 'mcap-windows-amd64.exe');
    
    if ~isfile(scriptPath)
        error('スクリプトが見つかりません。以下の場所を確認してください:\n%s', scriptPath);
    end

    % 入力/出力ファイルの絶対パスを構築
    % ファイル名のみが渡された場合、'data_mcap' フォルダ内であるとみなす
    if ~contains(inputFileName, '\') && ~contains(inputFileName, '/')
        inputFile = fullfile(homeDir, 'data_mcap', inputFileName);
    else
        inputFile = inputFileName;
    end

    % 指定されたtopicsからコマンドのオプションと出力ファイルのタグを生成
    [topics_opt, topics_tag] = format_mcap_topics(topics);
    
    [~,name,~] = fileparts(inputFile);
    outputFilePath = append(outputDir,name,topics_tag,'.json');
    
    % 入力ファイルの存在確認
    if ~isfile(inputFile)
        error('入力ファイルが見つかりません:\n%s', inputFile);
    end

    % コマンド構築
    if topics_opt == ""
        cmd = sprintf('%s cat %s --json > %s', scriptPath, inputFile, outputFilePath);
    else
        cmd = sprintf('%s cat %s --topics %s --json > %s', scriptPath, inputFile, topics_opt, outputFilePath);
    end
    
    disp('Convert : mcap >>> json ...');
    
    % コマンド実行
    [status, cmdout] = system(cmd);
    
    % 正常終了か異常終了かを出力
    if status == 0
        fprintf('変換が正常に完了しました。\n出力先: %s\n', outputFilePath);
    else
        fprintf('変換に失敗しました。\nエラー詳細:\n%s\n', cmdout);
    end
end