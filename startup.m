fileParam = Constants.FileParam();
MainFolderPath = fileParam.MainFolderPath;
Binary2CsvPath = fileParam.Binary2CsvPath;
contents  = dir(MainFolderPath+"*");

fig = uifigure;
d = uiprogressdlg(fig, 'Title', 'Starting Now...', 'Message', 'Start Up');

for k = 1:numel(contents)
	if ~isfolder(contents(k).name) || ~isempty(regexp(contents(k).name,'\.+','once')) || ~isempty(regexp(contents(k).name,'^\+','once'))
		continue;
	end
	addpath(fileParam.MainFolderPath + string(contents(k).name) + '\')
	d.Value = k / numel(contents);
	d.Message = contents(k).name;
end

close(fig);
clear d k fig fileParam;