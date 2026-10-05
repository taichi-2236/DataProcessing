%% data_plot_drienc.m %%
close all;
clear all;

datafile = "data/log_data_dribble_test_brake.txt";
data = load(datafile,"-ascii");

t_idx   = 1;
enc_idx = 5;

figure(1);
grid on;
hold on;
plot(data(1:4963,t_idx),data(1:4963,enc_idx),'r-',"LineWidth",2);
xlabel("time (ms)");
ylabel("encoder value");
legend("dri\_enc","Location","northwest");
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

[filepath,name,ext] = fileparts(datafile);
output = append("figure_log/",erase(name,'log_data_'),".pdf");
% output = "figure_log/dribble_test_continuous.pdf";
print(output,'-dpdf','-fillpage');