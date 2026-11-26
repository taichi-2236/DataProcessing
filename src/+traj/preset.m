%% traj.preset
% 実験用の定番目標経路パターンを名前から生成するファクトリ関数
%
% 引数:
%   name : プリセット名
%
% 戻り値:
%   segments : traj.Line / traj.Arc オブジェクトのcell配列
function segments = preset(name)
    arguments
        name (1,1) string = "Circle"
    end

    switch name
        case "Circle"
            segments = { ...
                traj.Arc([0.0; 0.0], 1.0) ...
            };
        
        case "CircStrt_Out"
            segments = { ...
                traj.Line([-2.0; 0.0], [-0.5; -sqrt(3)/2.0]), ...
                traj.Arc([0.0; 0.0], 1.0) ...
            };

        case "CircStrt_In"
            segments = { ...
                traj.Line([-0.5; 1.0], [-0.5; 1.0 - sqrt(3)/2.0]), ...
                traj.Arc([0.0; 1.0], 1.0) ...
            };

        case "Straight"
            segments = { ...
                traj.Line([-2.0; 0.0], [2.0; 0.0]) ...
            };

        otherwise
            error('未定義の経路プリセット名です: "%s"', name);
    end
end
