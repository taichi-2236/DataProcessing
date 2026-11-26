%% plot_sd_log.m
% SDカードから変換されたCSVログ (data/csv/from_SD) を読み込み、ドリブラPWM・エンコーダ推移を描画するスクリプト

close all;

paths    = Constants.FileParam();
datafile = fullfile(paths.DataCsvDir, "from_SD", "SD_data_ServoLockP_PDcircletest_pg150_NoN2.csv");
outDir   = fullfile(paths.OutputFigureDir, "sd_log");

data     = readmatrix(datafile);
last_row = size(data, 1);

time_idx       = 1;
driencdiro_idx = 6;
drirefvel_idx  = 11; %#ok<NASGU>
drivel_idx     = 16; %#ok<NASGU>
dricur_idx     = 21; %#ok<NASGU>
dripwm_idx     = 26;
sensor_idx     = 27; %#ok<NASGU>
dridiro_idx    = 28;

row_start  = min(20000, last_row);
row_finish = min(40000, last_row);

% 1. PWM値とエンコーダ値の推移
figure;
grid on;
hold on;
yyaxis left;
plot(data(row_start:row_finish, time_idx), data(row_start:row_finish, dripwm_idx), 'b-', 'LineWidth', 2);
xlabel("time(ms)");
ylabel("dri\_pwm");
ylim([-800, 800]);

yyaxis right;
plot(data(row_start:row_finish, time_idx), data(row_start:row_finish, driencdiro_idx), 'r-', 'LineWidth', 2);
ylabel("dri\_enc\_diro");
ylim([-3, 3]);

legend("dri\_pwm", "dri\_enc\_diro", "Location", "northeast");
set(gca, 'FontSize', 20);
set(gcf, 'PaperOrientation', 'landscape');
hold off;

output_figure(datafile, outDir, "pwm_");

% 2. PWM値と回転方向信号の推移
figure;
grid on;
hold on;
yyaxis left;
plot(data(row_start:row_finish, time_idx), data(row_start:row_finish, dripwm_idx), 'b-', 'LineWidth', 2);
ylabel("dri\_pwm");
xlabel("time(ms)");
ylim([-750, 750]);

yyaxis right;
plot(data(row_start:row_finish, time_idx), -2 * (data(row_start:row_finish, dridiro_idx) - 0.5), 'm-', 'LineWidth', 2);
ylabel("sign\_diro");
ylim([-3.0, 3.0]);

legend("dri\_pwm", "sign\_diro", "Location", "east");
set(gca, 'FontSize', 20);
set(gcf, 'PaperOrientation', 'landscape');
hold off;

output_figure(datafile, outDir, "pwmdiro_");
