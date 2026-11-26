%% Least Squares Method 1Dimention（最小二乗法による直線近似）
function [x,y_fit,p] = LSM_1D(x,y)
% Least Squares Method 1Dimention（最小二乗法による直線近似）
    p     = polyfit(x,y,1);
    y_fit = polyval(p,x);
end