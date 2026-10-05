function outputFileName = convert_bin2csv(inputFileName, scriptFolderPath)
	if ~exist("MainFolderPath","var")
		% 1. ホームディレクトリの絶対パスを自動取得する
		% mfilename('fullpath') はこの関数自身のフルパスを取得します
		funcPath = mfilename('fullpath');
		[funcDir, ~, ~] = fileparts(funcPath); % 'function' フォルダのパス
		homeDir = fileparts(funcDir);          % さらに上のホームディレクトリのパス
	else
		homeDir = MainFolderPath;
	end

	[~,name,~] = fileparts(inputFileName);
	outputFileName = append(name,'.csv');
	scriptPath = fullfile(scriptFolderPath,'drop_here.exe');

	if ~contains(inputFileName, '\') && ~contains(inputFileName, '/')
		inputFile = fullfile(homeDir, 'data_bin', inputFileName);
	else
		inputFile = inputFileName;
	end
	

	cmd = sprintf('%s %s', scriptPath, inputFile);
	
	[status, output] = system(cmd);
	
	if status == 0
		fprintf('変換が完了しました．%s\n', outputFileName);
	else
		fprintf('エラーが発生しました．\n');
		fprintf(output);
	end
end