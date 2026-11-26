%% traj.Arc
% 目標経路を構成する円・円弧セグメントクラス
classdef Arc
    properties
        centerPos  (2,1) double
        radius     (1,1) double
        angleRange (1,2) double = [0, 2*pi]
        LineStyle  (1,1) string = "--"
        Color      (1,1) string = "#FF0000"
        LineWidth  (1,1) double = 1.0
    end

    methods
        function obj = Arc(centerPos, radius, Opts)
            arguments
                centerPos       (2,1) double {mustBeReal}
                radius          (1,1) double {mustBeReal, mustBePositive}
                Opts.AngleRange (1,2) double {mustBeReal} = [0, 2*pi]
                Opts.LineStyle  (1,1) string = "--"
                Opts.Color      (1,1) string = "#FF0000"
                Opts.LineWidth  (1,1) double = 1.0
            end
            obj.centerPos  = centerPos;
            obj.radius     = radius;
            obj.angleRange = Opts.AngleRange;
            obj.LineStyle  = Opts.LineStyle;
            obj.Color      = Opts.Color;
            obj.LineWidth  = Opts.LineWidth;
        end

        function [x, y] = samplePoints(obj, nPoints)
            arguments
                obj
                nPoints (1,1) double {mustBeInteger, mustBeGreaterThanOrEqual(nPoints, 2)} = 100
            end
            theta = linspace(obj.angleRange(1), obj.angleRange(2), nPoints);
            x = obj.centerPos(1) + obj.radius * cos(theta);
            y = obj.centerPos(2) + obj.radius * sin(theta);
        end
    end
end
