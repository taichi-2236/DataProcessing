%% import_csv_SDcard.m

% # ===== データ取得 =====
if ~exist('auto', 'var')
	inputFileName = "SD_data_ServoLockP_pg12_NoN11.BIN";
end

inputDir  = "data_bin\"; 
outputDir = "data_csv\from_SD\";
[~,name,~] = fileparts(inputFileName);
outputFilePath = append(MainFolderPath,outputDir,name,'.csv');

csvFile = convert_bin2csv(inputFileName, Binary2CsvPath);
movefile(append(MainFolderPath, '\', inputDir, csvFile), outputDir);

clear inputDir outputDir
