%% convert_mcap2json
% mcapファイルをJSON Lines形式 (.json) に変換する関数
%
% 引数:
%   inputFileName : 変換元のmcapファイル名またはフルパス
%   outputDir     : 出力先ディレクトリ（省略時は data/json）
%   topics        : 抽出するtopicsのcell配列（省略または空の場合は全トピック）
function outputFilePath = convert_mcap2json(inputFileName, outputDir, topics)
    arguments
        inputFileName (1,1) string
        outputDir     (1,1) string = ""
        topics        cell         = {}
    end

    paths = Constants.FileParam();
    exePath = paths.McapExePath;
    if ~isfile(exePath)
        error('mcap CLI ツールが見つかりません:\n%s', exePath);
    end

    % 入力ファイルの解決（ファイル名のみの場合は data/mcap 配下を参照）
    if ~contains(inputFileName, "\") && ~contains(inputFileName, "/")
        inputFile = fullfile(paths.DataMcapDir, inputFileName);
    else
        inputFile = inputFileName;
    end
    if ~isfile(inputFile)
        error('入力mcapファイルが見つかりません:\n%s', inputFile);
    end

    % 出力先ディレクトリの解決と自動作成
    if outputDir == ""
        outputDir = paths.DataJsonDir;
    elseif ~java.io.File(outputDir).isAbsolute()
        outputDir = fullfile(paths.MainFolderPath, outputDir);
    end
    if ~isfolder(outputDir)
        mkdir(outputDir);
    end

    % トピックオプションとタグの生成
    [topics_opt, topics_tag] = format_mcap_topics(topics);

    [~, name, ~] = fileparts(inputFile);
    outputFilePath = string(fullfile(outputDir, append(name, topics_tag, ".json")));

    % コマンド構築（空白パス対応のためダブルクォートで保護）
    if topics_opt == ""
        cmd = sprintf('"%s" cat "%s" --json > "%s"', exePath, inputFile, outputFilePath);
    else
        cmd = sprintf('"%s" cat "%s" --topics %s --json > "%s"', exePath, inputFile, topics_opt, outputFilePath);
    end

    disp('Convert : mcap >>> json ...');
    [status, cmdout] = system(cmd);

    if status == 0
        fprintf('変換が正常に完了しました。\n出力先: %s\n', outputFilePath);
    else
        error('mcapからjsonへの変換に失敗しました。\nエラー詳細:\n%s', cmdout);
    end
end
