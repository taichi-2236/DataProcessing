classdef FileParam < handle
	properties
		MainFolderPath
		Binary2CsvPath
	end

	methods
		function obj = FileParam()
			obj.MainFolderPath = append(pwd,'\');
			cd('../Binary2csv/')
			obj.Binary2CsvPath = append(pwd,'\');
			disp("Link : " + obj.Binary2CsvPath);
			cd(obj.MainFolderPath);
			disp("Open : " + obj.MainFolderPath);
		end
		function delete(obj)
			if ~isa(obj,"FileParam")
				disp("Deleted : " + pwd);
			end
		end
	end
end
