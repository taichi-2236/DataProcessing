%% traj.Line
% 目標経路を構成する直線セグメントクラス
classdef Line
    properties
        startPos  (2,1) double
        finishPos (2,1) double
        LineStyle (1,1) string = "--"
        Color     (1,1) string = "#FF0000"
        LineWidth (1,1) double = 1.0
    end

    methods
        function obj = Line(startPos, finishPos, Opts)
            arguments
                startPos       (2,1) double {mustBeReal}
                finishPos      (2,1) double {mustBeReal}
                Opts.LineStyle (1,1) string = "--"
                Opts.Color     (1,1) string = "#FF0000"
                Opts.LineWidth (1,1) double = 1.0
            end
            obj.startPos  = startPos;
            obj.finishPos = finishPos;
            obj.LineStyle = Opts.LineStyle;
            obj.Color     = Opts.Color;
            obj.LineWidth = Opts.LineWidth;
        end

        function [x, y] = samplePoints(obj, nPoints)
            arguments
                obj
                nPoints (1,1) double {mustBeInteger, mustBeGreaterThanOrEqual(nPoints, 2)} = 2
            end
            x = linspace(obj.startPos(1), obj.finishPos(1), nPoints);
            y = linspace(obj.startPos(2), obj.finishPos(2), nPoints);
        end

        function len = length(obj)
            len = hypot(obj.finishPos(1) - obj.startPos(1), obj.finishPos(2) - obj.startPos(2));
        end

        function ang = angle(obj)
            ang = atan2(obj.finishPos(2) - obj.startPos(2), obj.finishPos(1) - obj.startPos(1));
        end
    end
end
