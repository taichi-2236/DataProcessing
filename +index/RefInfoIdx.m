%% RefInfoのデータ配列における列名クラス
classdef RefInfoIdx
	properties (SetAccess = immutable, GetAccess = public)
		seq   = 1 % 記録フレーム
		cmd   = 2 % Refereeコマンド
		stage = 3 % GameStage
		state = 4 % GameState
	end
end