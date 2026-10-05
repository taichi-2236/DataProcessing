%% auto_run.m
close all;

auto = true;

datafile = "";
alldata = dir("data_json\PushDribble_Circ_*_initerr*_NoN11_vision_ref.json");

if auto
	for i = 1:max(size(alldata))
		datafile = alldata(i).name;
		disp(datafile);
		run("import_csv_foxglove.m");
		run("plot_master.m")
	end
end

clear auto;