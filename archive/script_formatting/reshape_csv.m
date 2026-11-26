% datafile = "data/experiment2026-07-14-16-40-51.csv";
datafile = "data/07-15-13-34-57_71077.csv";

data = readmatrix(datafile);

rx_idx  = 3;
ry_idx  = 4;
ra_idx  = 5;
rvx_idx = 6;
rvy_idx = 7;
rva_idx = 8;
bx_idx  = 9;
by_idx  = 10;
bvx_idx = 11;
bvy_idx = 12;

time = size(data,1);

robot_xya = data(:,rx_idx:ra_idx);
ball_xy   = data(:,bx_idx:by_idx);

q_r(:,1:2) = robot_xya(:,1:2)/1000;
q_r(:,3)   = robot_xya(:,3);

q_b = ball_xy / 1000;