if (exist('auto') < 1)
    close all
end

% データ取得
if (exist('auto') < 1)
    % datafile = "data/robot_data_Circ_atan2_mu500_No1.dat";
    datafile = "data/robot_data_Circ_ServoLockP_pg100_NoN2.dat";
    % datafile = "data/robot_data_VisionTest_Strt_a0b1cm2_2_No2.dat";
    % datafile = "data/robot_data_VisionTest_x0y2000amPI6_Center_No2.dat";
    % datafile2 = "data/robot_data_VisionTest_mPI4_Left_No1.dat";
    % datafile3 = "data/robot_data_VisionTest_mPI4_Right_No1.dat";
end

data = load(datafile,'-ascii');
% data2 = load(datafile2,'-ascii');
% data3 = load(datafile3,'-ascii');

% サイズ取得
sz = size(data);

% 列の番号と値の対応
t_idx    = 1;
rx_idx   = 5;
ry_idx   = 6;
ra_idx   = 7;
bx_idx   = 8;
by_idx   = 9;
sv_idx   = 10;
ey_idx   = 11;
pa_idx   = 12;
ea_idx   = 13;
ph_idx   = 14;
va_idx   = 18;
ta_idx   = 19;
ta2_idx  = 24;
bfrx_idx = 25;
bfry_idx = 26;

% data(:,ra_idx) = data(:,ra_idx) + pi;
% data2(:,ra_idx) = data2(:,ra_idx) + pi;
% data3(:,ra_idx) = data3(:,ra_idx) + pi;

% figure(1)
% % 目標角度と実際の角度と角度の誤差
% subplot(2,1,1);
% grid on;
% hold on;
% plot(data(:,t_idx)/60,data(:,ra_idx),'k-','LineWidth',2);
% plot(data(:,t_idx)/60,data(:,ta_idx),'r-','LineWidth',2);
% plot(data(:,t_idx)/60,pi*ones(sz(1),1),'b--','LineWidth',1);
% plot(data(:,t_idx)/60,-pi*ones(sz(1),1),'b--','LineWidth',1);
% plot(data(:,t_idx)/60,pi*ones(sz(1),1)+pi/2,'c--','LineWidth',1);
% plot(data(:,t_idx)/60,-pi*ones(sz(1),1)+pi/2,'c--','LineWidth',1);
% xlim([0 data(sz(1),t_idx)/60]);
% % ylim([-pi/6 pi/3]);
% ylabel('angle (rad)');
% legend('robot\_angle','track\_angle','Location','northeast');
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

% subplot(2,1,2)
% grid on;
% hold on;
% plot(data(:,t_idx)/60,mod(data(:,ra_idx)-data(:,ta_idx),2*pi),'r-','LineWidth',2);
% plot(data(:,t_idx)/60,pi/7*ones(sz(1),1),'k--','LineWidth',1);
% legend('error\_angle', 'Location', 'northwest');
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

% [filepath,name,ext] = fileparts(datafile);
% output = append("figure2/",erase(name,'robot_data_'),".pdf");
% % print(output,'-dpdf','-fillpage');

% figure(2)
% grid on;
% hold on;
% plot(data(:,t_idx)/60,data(:,va_idx),'r-','LineWidth',2);
% xlabel('t (s)');
% ylabel('angle\_velocity (rad/s)');
% legend('angle\_vel','Location','northeast');
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

% [filepath,name,ext] = fileparts(datafile);
% output = append("figure2/ang_vel_",erase(name,'robot_data_'),".pdf");
% % print(output,'-dpdf','-fillpage');

ball_error_inDribbler = cos(data(:,ra_idx)) .* (data(:,by_idx) - data(:,ry_idx)) ...
                    - sin(data(:,ra_idx)) .* (data(:,bx_idx) - data(:,rx_idx));

wpb = data(:,bx_idx:by_idx);
% wpb2 = data2(:,bx_idx:by_idx);
% wpb3 = data3(:,bx_idx:by_idx);
wpr = data(:,rx_idx:ry_idx);
% wpr2 = data2(:,rx_idx:ry_idx);
% wpr3 = data3(:,rx_idx:ry_idx);
rpb = zeros(sz(1),2);
% rpb2 = zeros(sz(1),2);
% rpb3 = zeros(sz(1),2);

for i = 1:sz(1)-1
    rpb(i,:) = transpose(func_R(-data(i,ra_idx)) * (wpb(i,:) - wpr(i,:))');
    % rpb2(i,:) = transpose(func_R(-data2(i,ra_idx)) * (wpb2(i,:) - wpr2(i,:))');
    % rpb3(i,:) = transpose(func_R(-data3(i,ra_idx)) * (wpb3(i,:) - wpr3(i,:))');
end

ball_point = data(:,bx_idx:by_idx);
ball_norm = vecnorm(ball_point,2,2);

% rpb = func_R(-data(:,ra_idx)) * (wpb - wpr);

figure(3)
grid on;
hold on;
plot(data(:,t_idx)/60,ball_error_inDribbler/1000,'r-','LineWidth',2);
plot(data(:,t_idx)/60,data(:,bfry_idx)/1000,'b-','LineWidth',2);
% plot(data(:,t_idx)/60,rpb2(:,2)/1000,'b-','LineWidth',2);
% plot(data(:,t_idx)/60,rpb(:,2)/1000,'r-','LineWidth',2);
% plot(data(:,t_idx)/60,rpb3(:,2)/1000,'g-','LineWidth',2);
plot(data(:,t_idx)/60,0.03*ones(size(data(:,t_idx))),'k--','LineWidth',1);
plot(data(:,t_idx)/60,-0.03*ones(size(data(:,t_idx))),'k--','LineWidth',1);
% ylim([-0.05 0.05])
xlabel('t (s)');
ylabel('{}^ry_b (m)');
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
% legend('Left','Center','Right','Location','northeast');
hold off;

[filepath,name,ext] = fileparts(datafile);
output = append("figure2/ball_error_inDribbler_",erase(name,'robot_data_'),".pdf");
% output = append("figure2/ball_error_inDribbler_",erase(name,{'robot_data_','_Center'}),".pdf");
print(output,'-dpdf','-fillpage');

figure(4)
grid on;
hold on;
% plot(data(:,t_idx)/60,ball_error_inDribbler/1000,'r-','LineWidth',2);
plot(data(:,t_idx)/60,rpb(:,1)/1000,'r-','LineWidth',2);
plot(data(:,t_idx)/60,data(:,bfrx_idx)/1000,'b-','LineWidth',2);
% plot(data(:,t_idx)/60,0.03*ones(size(data(:,t_idx))),'k--','LineWidth',1);
% plot(data(:,t_idx)/60,-0.03*ones(size(data(:,t_idx))),'k--','LineWidth',1);
ylim([0.0 0.1])
xlabel('t (s)');
ylabel('{}^rx_b (m)');
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

[filepath,name,ext] = fileparts(datafile);
output = append("figure2/distance_Dribbler_ball_",erase(name,'robot_data_'),".pdf");
print(output,'-dpdf','-fillpage');


figure(5)
subplot(2,1,1);
grid on;
hold on;
plot(data(:,t_idx)/60,(ball_norm-1000)/1000,'-',"LineWidth",2,'Color','#007FFF');
% plot(data(:,t_idx)/60,data(:,by_idx)/1000,'-',"LineWidth",2,'Color','#FF8F00');
% xlabel('t (s)');
ylabel('{}^{ref}u_y (m/s)');

set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off; 

% figure(6)
subplot(2,1,2);
grid on;
hold on;
% plot(data(:,t_idx)/60,-data(:,ea_idx),'r-','LineWidth',2);
% plot(data(:,t_idx)/60,mod((atan2(ball_point(:,1),ball_point(:,2))+(pi/2))-data(:,ra_idx),2*pi)-pi,'-','LineWidth',2);
% plot(data(:,t_idx)/60,pi/4*ones(sz(1),1),'k--');
plot(data(:,t_idx)/60,pi/4+mod(atan2(ball_point(:,2),ball_point(:,1))+(pi/2)+atan2(0.04297*9.80665,ball_norm*pi/4*pi/4)+(ball_norm-1000)/1000-data(:,ra_idx),2*pi)-pi,'-','LineWidth',2,'Color','#007FFF');
% plot(data(:,t_idx)/60,data(:,ra_idx),'-','LineWidth',2);
xlabel('t(s)');
ylabel('{}^{ref}u_a (rad/s)');
ylim([0.0 0.8]);
yticks([0.0 0.2 0.4 0.6 0.8]);
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

[filepath,name,ext] = fileparts(datafile);
output = append("figure2/uy_ua_",erase(name,'robot_data_'),".pdf");
print(output,'-dpdf','-fillpage');

figure(7)
% CircleRadius = 1.0;
subplot(2,1,1)
grid on;
hold on;
% plot(data(:,t_idx)/60,-CircleRadius*cos(pi/4*data(:,t_idx)/60),'r--','LineWidth',1);
plot(data(:,t_idx)/60,-data(:,bx_idx)/1000,'-','LineWidth',2,'Color','#FF8F00');
ylabel('{}^wx_b (m)');
ylim([-2.0 2.0]);
yticks([-2.0 -1.0 0.0 1.0 2.0]);
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

subplot(2,1,2)
grid on;
hold on;
% plot(data(:,t_idx)/60,-CircleRadius*sin(pi/4*data(:,t_idx)/60),'r--','LineWidth',1);
plot(data(:,t_idx)/60,data(:,by_idx)/1000,'-','LineWidth',2,'Color','#FF8F00');
xlabel('t(s)');
ylabel('{}^wy_b (m)');
ylim([-2.0 2.0]);
yticks([-2.0 -1.0 0.0 1.0 2.0]);
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

[filepath,name,ext] = fileparts(datafile);
output = append("figure2/ball_xy_",erase(name,'robot_data_'),".pdf");
print(output,'-dpdf','-fillpage');