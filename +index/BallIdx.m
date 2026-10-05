%% Ballのデータ配列における列名クラス
classdef BallIdx
	properties (SetAccess = immutable, GetAccess = public)
		seq   = 1 % 記録フレーム
		x     = 2 % x座標
		y     = 3 % y座標
		vx    = 4 % world座標系での速度のx成分
		vy    = 5 % world座標系での速度のy成分
		speed = 6 % 速度の絶対値
		conf  = 7 % 生データにおける信用度
	end
end