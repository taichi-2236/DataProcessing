%% Robotのデータ配列における各ロボットの列名クラス
classdef RobotIdx
	properties (SetAccess = protected, GetAccess = public)
		seq   = 1 % 記録フレーム
		id    = 2 % ロボットID
		x     = 3 % x座標
		y     = 4 % y座標
		angle = 5 % 姿勢角
		vx    = 6 % world座標系での速度のx成分
		vy    = 7 % world座標系での速度のy成分
		speed = 8 % 速度ベクトルの絶対値
		conf  = 9 % 生データにおける信用度
	end
end