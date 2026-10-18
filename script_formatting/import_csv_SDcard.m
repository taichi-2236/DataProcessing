%% import_csv_SDcard.m
% SDカードのバイナリデータをCSVに変換
% <https://github.com/RoboDragons/Binary2csv Binary2Csv>を利用

%%% 1. データを取得

% データファイル指定（Autoの場合はスキップ）
if ~exist('auto', 'var')
	inputFileName = "SD_data_ServoLockP_pg12_NoN11.BIN";
end

% 出力ファイルを指定
inputDir  = "data_bin\";
outputDir = "data_csv\from_SD\";
[~,name,~] = fileparts(inputFileName);
outputFilePath = append(MainFolderPath,outputDir,name,'.csv');

%%% 2. CSVに変換
% Binary2Csvのツールで変換
csvFile = convert_bin2csv(inputFileName, Binary2CsvPath);
movefile(append(MainFolderPath, '\', inputDir, csvFile), outputDir);

%%% 3. 終了処理
clear inputDir outputDir
