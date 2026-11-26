%% velo_data_plot.m
close all

% import %
datafile = "data/robot_data_KickTest_3000mmps_3_No2.dat";
data = load(datafile,'-ascii');

sz = size(data);

ball_vel_x = zeros(sz(1)-1,1);
ball_vel_y = zeros(sz(1)-1,1);

t_idx  = 1;
bx_idx = 8;
by_idx = 9;

for i=2:sz(1)
    ball_vel_x(i-1) = (data(i,bx_idx) - data(i-1,bx_idx)) * 60;
    ball_vel_y(i-1) = (data(i,by_idx) - data(i-1,by_idx)) * 60;
end

figure(1)
grid on;
hold on;
plot(data(1:sz(1)-1,t_idx),ball_vel_x,'r-','LineWidth',2);
plot(data(1:sz(1)-1,t_idx),ball_vel_y,'b-','LineWidth',2);
xlabel('frame'); ylabel("ball velocity (mm/s)");
legend('v_x','v_y','Location','southeast');
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

[filepath,name,ext] = fileparts(datafile);
output = append("figure2/ball_vel_",erase(name,'robot_data_'),".pdf");
% print(output,'-dpdf','-fillpage');

t = 200;
v_s = ball_vel_x(t)/1000;
x_s = data(t,bx_idx)/1000;

dt = 100;

t = t + dt;
v_f = ball_vel_x(t)/1000;
x_f = data(t,bx_idx)/1000;

g = 9.80665;

dt = dt/60;

mu = (v_s*dt + x_s - x_f)*2/(dt^2*g)
mu = 7 * (v_s^2 - v_f^2) / (10 * g * (x_f - x_s))