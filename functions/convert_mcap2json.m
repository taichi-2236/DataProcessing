% convert_mcap2json.m
function outputFilePath = convert_mcap2json(inputFileName,outputDir)
    if ~exist("MainFolderPath","var")
        % 1. ホームディレクトリの絶対パスを自動取得する
        % mfilename('fullpath') はこの関数自身のフルパスを取得します
        funcPath = mfilename('fullpath');
        [funcDir, ~, ~] = fileparts(funcPath); % 'function' フォルダのパス
        homeDir = fileparts(funcDir);          % さらに上のホームディレクトリのパス
    else
        homeDir = MainFolderPath;
    end

    % 2. Pythonスクリプトの絶対パスを構築
    scriptPath = fullfile(homeDir, '+Tools', 'mcap-windows-amd64.exe');
    
    if ~isfile(scriptPath)
        error('スクリプトが見つかりません。以下の場所を確認してください:\n%s', scriptPath);
    end

    % 3. 入力/出力ファイルの絶対パスを構築
    % ファイル名のみが渡された場合、'data_mcap' フォルダ内であるとみなす
    if ~contains(inputFileName, '\') && ~contains(inputFileName, '/')
        inputFile = fullfile(homeDir, 'data_mcap', inputFileName);
    else
        inputFile = inputFileName;
    end

    [~,name,~] = fileparts(inputFile);
    outputFilePath = append(outputDir,name,'_vision','_ref','.json');
    
    % 入力ファイルの存在確認
    if ~isfile(inputFile)
        error('入力ファイルが見つかりません:\n%s', inputFile);
    end

    % 4. コマンドの構築と実行
    cmd = sprintf('%s cat %s --topics /vision,/referee --json > %s', scriptPath, inputFile, outputFilePath);
    
    disp('変換を開始します...');
    
    % コマンド実行
    [status, cmdout] = system(cmd);
    
    if status == 0
        fprintf('\n変換が正常に完了しました。\n出力先: %s\n', outputFilePath);
    else
        fprintf('\n変換に失敗しました。\nエラー詳細:\n%s\n', cmdout);
    end
end