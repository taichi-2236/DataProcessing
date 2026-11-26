%% FileParam
% プロジェクト内の主要ディレクトリと外部ツールの絶対パスを管理する定数クラス
classdef FileParam
    properties (SetAccess = immutable)
        MainFolderPath  (1,1) string
        Binary2CsvPath  (1,1) string
        DataBinDir      (1,1) string
        DataMcapDir     (1,1) string
        DataJsonDir     (1,1) string
        DataCsvDir      (1,1) string
        DataDatDir      (1,1) string
        DataTxtDir      (1,1) string
        OutputFigureDir (1,1) string
        OutputMovieDir  (1,1) string
        McapExePath     (1,1) string
    end

    methods
        function obj = FileParam()
            % src/+Constants/FileParam.m の2階層上がプロジェクトルート
            constDir = fileparts(mfilename('fullpath'));
            srcDir   = fileparts(constDir);
            rootDir  = fileparts(srcDir);

            obj.MainFolderPath  = string(fullfile(rootDir, filesep));
            obj.Binary2CsvPath  = string(fullfile(fileparts(rootDir), 'Binary2csv', filesep));
            obj.DataBinDir      = string(fullfile(rootDir, 'data', 'bin'));
            obj.DataMcapDir     = string(fullfile(rootDir, 'data', 'mcap'));
            obj.DataJsonDir     = string(fullfile(rootDir, 'data', 'json'));
            obj.DataCsvDir      = string(fullfile(rootDir, 'data', 'csv'));
            obj.DataDatDir      = string(fullfile(rootDir, 'data', 'dat'));
            obj.DataTxtDir      = string(fullfile(rootDir, 'data', 'txt'));
            obj.OutputFigureDir = string(fullfile(rootDir, 'output', 'figure'));
            obj.OutputMovieDir  = string(fullfile(rootDir, 'output', 'movie'));
            obj.McapExePath     = string(fullfile(rootDir, 'tools', 'mcap-windows-amd64.exe'));
        end
    end
end
