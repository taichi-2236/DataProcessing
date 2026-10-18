%% plot_master
% 1台のロボットで実験した際のロボットとボールの軌跡のプロット
% NormalStart実行中のみのデータを処理する

%%% 1. 初期化処理
clear q_r q_b

r = index.RobotIdx;
b = index.BallIdx;

%%% 2. NormalStartに該当するindexを抽出
active_seq = str2double(ref_info(ref_info(:,2) == "Ready"));

start  = active_seq(1);
finish = active_seq(end);

% ログ内の複数の実験を分割
split_edge_idx = [start, finish];
% split_edge_idx = find_discontinuous_idx(active_seq);

%%% 3. 分割された実験ごとにデータ処理
for k = 1:size(split_edge_idx,1)
	tmp_datafile = datafile;
	start  = split_edge_idx(k,1);
	finish = split_edge_idx(k,2);

	% 実験が複数ある場合は生成ファイルの末尾にナンバリング
	if size(split_edge_idx) > 1
		[dir,name,ext] = fileparts(datafile);
		datafile = append(dir,name,'_',string(k),ext);
	end
	
	% 記録されているチームカラーのロボットの姿勢情報を格納
	if exist('yellow_robot', 'var')
		q_r(:,1:2) = yellow_robot(start:finish,r.x:r.y) / 1000;
		q_r(:,3)   = yellow_robot(start:finish,r.angle);
	elseif exist('blue_robot', 'var')
		q_r(:,1:2) = blue_robot(start:finish,r.x:r.y) / 1000;
		q_r(:,3)   = blue_robot(start:finish,r.angle);
	end

	% ballの情報を格納
	if exist('ball', 'var')
		q_b = ball(start:finish,b.x:b.y) / 1000;
	end

	% 軌跡図生成
	run("plot_orbit");

	datafile = tmp_datafile;

	clear q_r q_b tmp_datafile
end

%%% 4. 終了処理
clear r b start finish active_seq split_edge_idx