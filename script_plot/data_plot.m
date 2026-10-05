close all

% データ取得

datafile = "data/robot_data_VisionTest_Strt_a0b1cm2_No2.dat";
data = load(datafile,'-ascii');

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
be_idx   = 15;

pos_start = [ -4.0; -2.0 ];
pos_finish = [ 1.5; -2.0 ];
track_angle = atan2(pos_finish(2)-pos_start(2),pos_finish(1)-pos_start(1));

dist = @(p_s,p_f,p) ((p_f(2)-p_s(2))*(p(:,1)-p_s(1))-(p_f(1)-p_s(1))*(p(:,2)-p_s(2)))/sqrt((p_f(2)-p_s(2))^2+(p_f(1)-p_s(1))^2);

figure(1)
% 目標軌道の座標と実際の座標と座標の誤差
subplot(5,1,1:2);
grid on;
hold on;
% plot(data(:,t_idx)/60,data(:,sv_idx)/1000,'r-','LineWidth',2);
% plot(data(2:sz(1),t_idx)/60,data(2:sz(1),be_idx)/1000,'r-','LineWidth',2);
plot(data(2:sz(1),t_idx)/60,-2.0*ones(size(data(2:sz(1),t_idx))),'-','LineWidth',2,'Color','#FF0000');
plot(data(2:sz(1),t_idx)/60,-data(2:sz(1),ry_idx)/1000,'b-','LineWidth',2);
% plot(data(2:sz(1),t_idx)/60,dist(pos_start,pos_finish,-data(2:sz(1),rx_idx:ry_idx)/1000),...
    % 'b-','LineWidth',2);
    plot(data(2:sz(1),t_idx)/60,-data(2:sz(1),by_idx)/1000,'.','LineWidth',2,'Color','#FF8F00');
% plot(data(:,t_idx)/60,data(:,15)/1000,'-','LineWidth',2,'Color','#FF8F00');
% plot(data(2:sz(1),t_idx)/60,data(2:sz(1),ey_idx)/1000,'g-','LineWidth',2);
% xlim([0 10.0]);
xlim([0 data(sz(1),t_idx)/60]);
ylabel('y (m)');
% legend('{}^ty^*_b','{}^ty_b','Location','southeast');
% legend('reference path for ball','robot', 'ball','Location','southeast');
legend('reference path for ball','robot', 'ball','Location','northwest');
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

% 目標角度と実際の角度と角度の誤差
subplot(5,1,3:4);
grid on;
hold on;
% plot(data(:,t_idx)/60,data(:,pa_idx),'r-','LineWidth',2);
plot(data(2:sz(1),t_idx)/60,data(2:sz(1),pa_idx),'r-','LineWidth',2);
% plot(data(:,t_idx)/60,data(:,ra_idx)-data(:,19),'b-','LineWidth',2);
plot(data(2:sz(1),t_idx)/60,data(2:sz(1),ra_idx),'b-','LineWidth',2);
% plot(data(2:sz(1),t_idx)/60,data(2:sz(1),ea_idx),'g-','LineWidth',2);
xlim([0 data(sz(1),t_idx)/60]);
% ylim([-pi/6 pi/3]);
ylabel('angle (rad)');
% legend('{}^w\phi^*','{}^w\theta_r','Location','northeast');
legend('{}^w\phi^*','{}^w\theta_r','Location','southeast');
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;


% 制御を切り替えるフラグ
subplot(5,1,5);
grid on;
hold on;
plot(data(2:sz(1),t_idx)/60,data(2:sz(1),ph_idx),'bo-','LineWidth',1);
% xlim([0 10.0]);
xlim([0 data(sz(1),t_idx)/60]);
xlabel('t (s)'); ylabel('mode');
yticklabels({'0','1a','1b'});
% legend('phase','Location','northeast');
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

[filepath,name,ext] = fileparts(datafile);
output = append("figure2/",erase(name,'robot_data_'),".pdf");
print(output,'-dpdf','-fillpage');

% figure(2)
% grid on;
% hold on;
% plot(data(2:sz(1),t_idx)/60,data(2:sz(1),bx_idx),'-','LineWidth',2,'Color','#FF8F00');
% xlim([0 10.0]);
% xlabel('time[sec]'); ylabel('x[m]');
% legend('ball\_x','Location','northeast');
% hold off;

% figure(2)
% grid on;
% hold on;
% plot(data(1:sz(1)-1,1)/60,-diff(:,1)/1000,'m-','LineWidth',2);
% legend("variation", "Location", "southeast");
% xlim([0 data(sz(1),t_idx)/60]);
% xlabel("t (s)"); ylabel("variation (m)");
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

% figure(2)
% % 目標角度と実際の角度と角度の誤差
% subplot(3,1,1);
% grid on;
% hold on;
% plot(data(:,t_idx)/60,data(:,pa_idx),'r-','LineWidth',2);
% plot(data(:,t_idx)/60,data(:,ra_idx)-data(:,19),'b-','LineWidth',2);
% % plot(data(2:sz(1),t_idx)/60,data(2:sz(1),ea_idx),'g-','LineWidth',2);
% xlim([0 data(sz(1),t_idx)/60]);
% % ylim([-pi/6 pi/3]);
% ylabel('angle (rad)');
% legend('{}^w\phi^*','{}^w\theta_r','Location','northeast');
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

% subplot(3,1,2);
% grid on;
% hold on;
% plot(data(:,t_idx)/60,data(:,18),'-','LineWidth',2,'Color','#FF00FF');
% xlim([0 data(sz(1),t_idx)/60]);
% ylabel('ang vel (rad/s)');
% % legend('ang vel (rad/s)','Location','southeast')
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

% subplot(3,1,3)
% grid on;
% hold on;
% plot(data(:,t_idx)/60,data(:,7),'-','LineWidth',2,'Color','#FF0000');
% xlim([0 data(sz(1),t_idx)/60]);
% xlabel('t (s)'); ylabel('robo angle (rad)');
% % legend('ang vel (rad/s)','Location','southeast')
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

% [filepath,name,ext] = fileparts(datafile);
% output = append("figure2/variation_y_",erase(name,'robot_data_'),".pdf");
% print(output,'-dpdf','-fillpage');

% figure(3)
% ボールとロボットの座標の時間変化
% subplot(2,1,1);
% grid on;
% hold on;
% plot(data(2:sz(1),t_idx)/60,-data(2:sz(1),rx_idx)/1000,'-','LineWidth',2,'Color','#007FFF');
% plot(data(2:sz(1),t_idx)/60,-data(2:sz(1),bx_idx)/1000,'-','LineWidth',2,'Color','#FF8F00');
% xlim([0 data(sz(1),t_idx)/60]);
% ylabel('x (m)');
% legend('robot','ball','Location','southeast');
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;
% 
% subplot(2,1,2);
% grid on;
% hold on;
% plot(data(2:sz(1),t_idx)/60,-data(2:sz(1),ry_idx)/1000,'-','LineWidth',2,'Color','#007FFF')
% plot(data(2:sz(1),t_idx)/60,-data(2:sz(1),by_idx)/1000,'-','LineWidth',2,'Color','#FF8F00');
% xlim([0 data(sz(1),t_idx)/60]);
% xlabel('t (s)');
% ylabel('y (m)');
% legend('robot','ball','Location','southeast');
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;
% 
% [filepath,name,ext] = fileparts(datafile);
% output = append("figure2/t_xy_",erase(name,'robot_data_'),".pdf");
% print(output,'-dpdf','-fillpage');
% 
% figure(4)
% grid on;
% hold on;
% plot(data(2:sz(1),t_idx)/60,(-data(2:sz(1),ry_idx)/1000 + 1.5)./sin(-data(2:sz(1),ra_idx)),'b-','LineWidth',2);
% xlim([0 data(sz(1),t_idx)/60]);
% xlabel('t (s)'); ylabel('distance (m)');
% legend('robot','Location','southeast');
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;
% 
% [filepath,name,ext] = fileparts(datafile);
% output = append("figure2/norm_",erase(name,'robot_data_'),".pdf");
% print(output,'-dpdf','-fillpage');
% 
% figure(5)
% grid on;
% hold on;
% plot(data(2:sz(1),t_idx)/60,0.032*ones(sz(1)-1),'k--','LineWidth',1,'HandleVisibility','off');
% plot(data(2:sz(1),t_idx)/60,-0.032*ones(sz(1)-1),'k--','LineWidth',1,'HandleVisibility','off');
% plot(data(2:sz(1),t_idx)/60,0.078*tan(atan2(-data(2:sz(1),by_idx)+data(2:sz(1),ry_idx),-data(2:sz(1),bx_idx)+data(2:sz(1),rx_idx))-data(2:sz(1),ra_idx)),'r-','LineWidth',2);
% xlabel('t (s)'); ylabel('${}^ry_b$ (m)','Interpreter','latex');
% legend('ball', 'Location', 'southeast');
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;
% 
% [filepath,name,ext] = fileparts(datafile);
% output = append("figure2/RCS_",erase(name,'robot_data_'),".pdf");
% print(output,'-dpdf','-fillpage');
% 