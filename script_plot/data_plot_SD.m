%% data_plot_SD.m
close all;
clear all;

% datafile = "binary2csv_v1-2/CSV_data/SD_data_ServoLockP_encdirotest_pwm500_2_NoN2.csv";
% datafile = "binary2csv_v1-2/CSV_data/SD_data_ServoLockP_sddatatest2_NoN2.csv";
% datafile = "binary2csv_v1-2/CSV_data/SD_data_ServoLockP_encdiro_pg150_NoN2.csv";
datafile = "binary2csv_v1-2/CSV_data/SD_data_ServoLockP_PDcircletest_pg150_NoN2.csv";
data = load(datafile,"-ascii");
last_row = size(data,1);

time_idx       = 1;
driencdiro_idx = 6;
drirefvel_idx  = 11;
drivel_idx     = 16;
dricur_idx     = 21;
dripwm_idx     = 26;
sensor_idx     = 27;
dridiro_idx    = 28;

row_start = 20000;
row_finish = 40000;
% row_finish = last_row

% row = find(bitand(data(:,sensor_idx),1)>0);

% figure % 
% figure(1)
% grid on;
% hold on;
% plot(data(row_start:row_finish,time_idx),data(row_start:row_finish,driencdiro_idx),'r-','LineWidth',2);
% % plot(data(:,time_idx),data(:,driencdiro_idx),'r-','LineWidth',2);
% % plot(data(:,time_idx),bitand(data(:,sensor_idx),1),'b-','LineWidth',2);
% xlabel("time(ms)");
% ylabel("dri\_enc");
% legend("dri\_enc","Location","northeast");
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

% output_figure(datafile,"figure_log/","SD_");

% figure(2)
% grid on;
% hold on;
% yyaxis left;
% plot(data(row_start:row_finish,time_idx),data(row_start:row_finish,drirefvel_idx),'b-','LineWidth',2);
% xlabel("time(ms)");
% ylabel("dri\_refvel");
% % ylim([0 30]);

% yyaxis right
% plot(data(row_start:row_finish,time_idx),data(row_start:row_finish,driencdiro_idx),'r-','LineWidth',2);
% ylabel("dri\_enc");

% legend("dri\_refvel","dri\_enc","Location","northeast");
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

% figure(3)
% grid on;
% hold on;
% yyaxis left;
% plot(data(row_start:row_finish,time_idx),data(row_start:row_finish,drivel_idx),'b-','LineWidth',2);
% xlabel("time(ms)");
% ylabel("dri\_vel");
% % ylim([0 30]);

% yyaxis right
% plot(data(row_start:row_finish,time_idx),data(row_start:row_finish,driencdiro_idx),'r-','LineWidth',2);
% ylabel("dri\_enc");

% legend("dri\_vel","dri\_enc","Location","northeast");
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

figure(4)
grid on;
hold on;
yyaxis left;
plot(data(row_start:row_finish,time_idx),data(row_start:row_finish,dripwm_idx),'b-','LineWidth',2);
% plot(data(1:2000,time_idx),data(1:2000,dripwm_idx),'b-','LineWidth',2);
% plot(data(4300:6000,time_idx),data(4300:6000,dripwm_idx),'b-','LineWidth',2);
xlabel("time(ms)");
ylabel("dri\_pwm");
ylim([-800 800]);

yyaxis right
plot(data(row_start:row_finish,time_idx),data(row_start:row_finish,driencdiro_idx),'r-','LineWidth',2);
% plot(data(1:2000,time_idx),data(1:2000,driencdiro_idx),'r-','LineWidth',2);
% plot(data(4300:6000,time_idx),data(4300:6000,driencdiro_idx),'r-','LineWidth',2);
ylabel("dri\_enc\_diro");
ylim([-3 3]);

% title("PWM値とエンコーダ値の推移")
legend("dri\_pwm","dri\_enc\_diro","Location","northeast");
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

output_figure(datafile,"figure_log/","pwm_");

% figure(5)
% grid on;
% hold on;
% yyaxis left;
% plot(data(row_start:row_finish,time_idx),-2*(data(row_start:row_finish,sensor_idx)-0.5),'b-','LineWidth',2);
% xlabel("time(ms)");
% ylabel("sign\_diro");
% ylim([-1.5 1.5]);

% yyaxis right
% plot(data(row_start:row_finish,time_idx),data(row_start:row_finish,driencdiro_idx),'r-','LineWidth',2);
% ylabel("dri\_enc\_diro");

% title("回転方向の信号とエンコーダ値の推移");
% legend("sign\_diro","dri\_enc\_diro","Location","northeast");
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

% output_figure(datafile,"figure_log/","encdiro_");

figure(6)
grid on;
hold on;
yyaxis left;
plot(data(row_start:row_finish,time_idx),data(row_start:row_finish,dripwm_idx),'b-','LineWidth',2);
ylabel("dri\_pwm");
xlabel("time(ms)");
ylim([-750 750]);

yyaxis right
plot(data(row_start:row_finish,time_idx),-2*(data(row_start:row_finish,dridiro_idx)-0.5),'m-','LineWidth',2);
ylabel("sign\_diro");
ylim([-3.0 3.0]);

% title("PWM値と回転方向の信号の推移")
legend("dri\_pwm","sign\_diro","Location","east");
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

output_figure(datafile,"figure_log/","pwmdiro_");