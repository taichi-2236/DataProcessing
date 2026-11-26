%% init_anim.m
close all
if(exist('auto') < 1)
    clear all 
end

% input %
if(exist('auto') < 1)
    % datafile = "data/robot_data_StrtP_phase_target1500_maxwPI4_Startx0_No11.dat";
    % datafile = "data/robot_data_StrtP_phase_targetx1500y1500_KpP1000G300F200_KaPPI4GPI6FPI4_maxwPI4_No11.dat";
    % datafile = "data/robot_data_StrtPfix_No5_3.dat";
    datafile = "data/robot_data_Circ_atan2_mu272_No5.dat";
    % datafile = "data/robot_data_Circ_NoN2.dat";
    % datafile = "data/robot_data_Circ_ServoLockP_pg100_NoN2.dat";
    % datafile = "data/robot_data_VisionTest_Strt_a0b1cm2_2_No2.dat";
    % datafile = "data/robot_data_VisionTest_x0y2000a0_Center_No2.dat";
    % datafile = "data/robot_data.dat";
    % datafile = "data/robot_data_StrtP_onlyPush_KpP1000_KaPPI4_maxwPI4_No11.dat";
end
t_idx    = 1;
rx_idx   = 5;
ry_idx   = 6;
ra_idx   = 7;
bx_idx   = 8;
by_idx   = 9;

% load data %
data = load(datafile, "-ascii");

% variable definition %
tout = data(:,t_idx);
if(max([rx_idx,ry_idx,ra_idx]) > max(size(data(1,:))))
    error("This does not include robot data.");
else
    q_r  = data2q_r(data, rx_idx, ry_idx, ra_idx);
end
if(max([bx_idx,by_idx]) > max(size(data(1,:))))
    error("This does not include ball data.");
else
    q_b = data2q_b(data, bx_idx, by_idx);
end

disp("loading complete");

%% function
% func data2q_r %
function q_r = data2q_r(data, rx_idx, ry_idx, ra_idx)
    q_r(:,1) = -data(:,rx_idx) / 1000;
    q_r(:,2) = -data(:,ry_idx) / 1000;
    q_r(:,3) = data(:,ra_idx);
end

% func data2q_b %
function q_b = data2q_b(data, bx_idx, by_idx)
    q_b(:,1) = -data(:,bx_idx) / 1000 + 0.05;
    q_b(:,2) = -data(:,by_idx) / 1000;
end
