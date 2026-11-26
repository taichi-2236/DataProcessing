%% startup.m
% プロジェクトの検索パスと基本パス変数を初期化するスクリプト

rootDir = fileparts(mfilename('fullpath'));
addpath(rootDir);
addpath(genpath(fullfile(rootDir, 'src')));
addpath(genpath(fullfile(rootDir, 'scripts')));

fileParam = Constants.FileParam();
MainFolderPath = fileParam.MainFolderPath;
Binary2CsvPath = fileParam.Binary2CsvPath;

disp("Open : " + MainFolderPath);
clear rootDir fileParam;
