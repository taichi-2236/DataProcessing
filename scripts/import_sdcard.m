%% import_sdcard.m
% SDカードのバイナリデータ (.BIN) をCSVに変換し data/csv/from_SD へ格納するスクリプト
% Binary2Csv (https://github.com/RoboDragons/Binary2csv) を利用

%%% 1. 入力ファイルの指定
inputFileName = "SD_data_ServoLockP_pg12_NoN11.BIN";

%%% 2. CSVへ変換して出力フォルダへ移動
paths     = Constants.FileParam();
outputDir = fullfile(paths.DataCsvDir, "from_SD");
if ~isfolder(outputDir)
    mkdir(outputDir);
end

[csvFileName, generatedPath] = convert_bin(inputFileName, ".csv", paths.Binary2CsvPath);
outputFilePath = fullfile(outputDir, csvFileName);
movefile(generatedPath, outputFilePath);

fprintf('出力先: %s\n', outputFilePath);
clear paths outputDir csvFileName generatedPath;
