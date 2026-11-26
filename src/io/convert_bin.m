%% convert_bin
% バイナリログ (.bin) を指定形式 (.csv または .mcap) に変換する関数
%
% 引数:
%   inputFileName    : 変換元の .bin ファイル名（またはフルパス）
%   targetExt        : 出力拡張子 (".csv" または ".mcap", デフォルト ".csv")
%   scriptFolderPath : drop_here.exe が格納されているフォルダパス（省略時は FileParam.Binary2CsvPath）
function [outputFileName, outputFilePath] = convert_bin(inputFileName, targetExt, scriptFolderPath)
    arguments
        inputFileName    (1,1) string
        targetExt        (1,1) string = ".csv"
        scriptFolderPath (1,1) string = ""
    end

    paths = Constants.FileParam();

    if ~startsWith(targetExt, ".")
        targetExt = "." + targetExt;
    end
    targetExt = lower(targetExt);
    if targetExt ~= ".csv" && targetExt ~= ".mcap"
        error('未対応の出力拡張子です: %s (".csv" または ".mcap" を指定してください)', targetExt);
    end

    if scriptFolderPath == ""
        scriptFolderPath = paths.Binary2CsvPath;
    end
    exePath = fullfile(scriptFolderPath, "drop_here.exe");
    if ~isfile(exePath)
        error('変換ツールが見つかりません:\n%s', exePath);
    end

    if ~contains(inputFileName, "\") && ~contains(inputFileName, "/")
        inputFile = fullfile(paths.DataBinDir, inputFileName);
    else
        inputFile = inputFileName;
    end
    if ~isfile(inputFile)
        error('入力バイナリファイルが見つかりません:\n%s', inputFile);
    end

    [inDir, name, ~] = fileparts(inputFile);
    outputFileName = append(name, targetExt);
    outputFilePath = fullfile(inDir, outputFileName);

    cmd = sprintf('"%s" "%s"', exePath, inputFile);
    fprintf('Convert : bin >>> %s ...\n', erase(targetExt, "."));

    [status, cmdout] = system(cmd);
    if status == 0
        fprintf('変換が完了しました．%s\n', outputFileName);
    else
        error('バイナリ変換中にエラーが発生しました:\n%s', cmdout);
    end
end
