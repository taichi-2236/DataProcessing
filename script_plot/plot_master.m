%% execute plot_orbit
clear q_r q_b
active_seq = str2double(ref_info(ref_info(:,2) == "Ready"));

r = index.RobotIdx;
b = index.BallIdx;

% sz = size(ref_info);
% start  = 1;
% finish = sz(1);
start  = active_seq(1);
finish = active_seq(end);
% start  = 1932;
% finish = 3334;
% start  = 6333;
% finish = 6800;

% ログ内の複数の実験を分割
% split_edge_idx = find_discontinuous_idx(active_seq);
split_edge_idx = [start, finish];
% split_edge_idx = [1750, 4850];
for k = 1:size(split_edge_idx,1)
	tmp_datafile = datafile;
	start  = split_edge_idx(k,1);
	finish = split_edge_idx(k,2);

	% 実験が複数ある場合は生成ファイルの末尾にナンバリング
	if size(split_edge_idx) > 1
		[dir,name,ext] = fileparts(datafile);
		datafile = append(dir,name,'_',string(k),ext);
	end
	
	q_r(:,1:2) = yellow_robot(start:finish,r.x:r.y) / 1000;
	q_r(:,3)   = yellow_robot(start:finish,r.angle);
	% q_r(:,1:2) = blue_robot(start:finish,r.x:r.y) / 1000;
	% q_r(:,3)   = blue_robot(start:finish,r.angle);
	% q_r(:,1:2) = raw_blue_robot(start:finish,r.x:r.y) / 1000;
	% q_r(:,3)   = raw_blue_robot(start:finish,r.angle); 
	q_b        = ball(start:finish,b.x:b.y) / 1000;
	% q_b        = raw_ball(start:finish,b.x:b.y) / 1000;

	run("plot_orbit");

	datafile = tmp_datafile;

	clear q_r q_b
end
% run("anim")
clear tmp_datafile