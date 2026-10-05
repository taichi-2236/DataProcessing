close all;
clear all;

ballrawx_idx = 29;
ballrawy_idx = 30;

% load %
data_x0y0     = load("vision_check/ball_data_x0y0_before.dat","-ascii");
data_x0y30    = load("vision_check/ball_data_x0y30_before.dat","-ascii");
data_x0ym30   = load("vision_check/ball_data_x0ym30_before.dat","-ascii");
data_x45y0    = load("vision_check/ball_data_x45y0_before.dat","-ascii");
data_x45y30   = load("vision_check/ball_data_x45y30_before.dat","-ascii");
data_x45ym30  = load("vision_check/ball_data_x45ym30_before.dat","-ascii");
data_xm45y0   = load("vision_check/ball_data_xm45y0_before.dat","-ascii");
data_xm45y30  = load("vision_check/ball_data_xm45y30_before.dat","-ascii");
data_xm45ym30 = load("vision_check/ball_data_xm45ym30_before.dat","-ascii");

% calc %
mean_data_x0y0 = mean(data_x0y0(:,ballrawx_idx:ballrawy_idx));
mean_data_x0y30 = mean(data_x0y30(:,ballrawx_idx:ballrawy_idx));
mean_data_x0ym30 = mean(data_x0ym30(:,ballrawx_idx:ballrawy_idx));
mean_data_x45y0 = mean(data_x45y0(:,ballrawx_idx:ballrawy_idx));
mean_data_x45y30 = mean(data_x45y30(:,ballrawx_idx:ballrawy_idx));
mean_data_x45ym30 = mean(data_x45ym30(:,ballrawx_idx:ballrawy_idx));
mean_data_xm45y0 = mean(data_xm45y0(:,ballrawx_idx:ballrawy_idx));
mean_data_xm45y30 = mean(data_xm45y30(:,ballrawx_idx:ballrawy_idx));
mean_data_xm45ym30 = mean(data_xm45ym30(:,ballrawx_idx:ballrawy_idx));

fprintf('( ball_x, ball_y)\n');
fprintf('(%7.3f,%7.3f)  ',mean_data_xm45y30(1)/1000,mean_data_xm45y30(2)/1000);
fprintf('(%7.3f,%7.3f)  ',mean_data_x0y30(1)/1000,mean_data_x0y30(2)/1000);
fprintf('(%7.3f,%7.3f)\n',mean_data_x45y30(1)/1000,mean_data_x45y30(2)/1000);
fprintf('(%7.3f,%7.3f)  ',mean_data_xm45y0(1)/1000,mean_data_xm45y0(2)/1000);
fprintf('(%7.3f,%7.3f)  ',mean_data_x0y0(1)/1000,mean_data_x0y0(2)/1000);
fprintf('(%7.3f,%7.3f)\n',mean_data_x45y0(1)/1000,mean_data_x45y0(2)/1000);
fprintf('(%7.3f,%7.3f)  ',mean_data_xm45ym30(1)/1000,mean_data_xm45ym30(2)/1000);
fprintf('(%7.3f,%7.3f)  ',mean_data_x0ym30(1)/1000,mean_data_x0ym30(2)/1000);
fprintf('(%7.3f,%7.3f)\n',mean_data_x45ym30(1)/1000,mean_data_x45ym30(2)/1000);

% plot %
figure(1)
% grid on;
plot_field();
hold on;
plot(mean_data_x0y0(1)/1000,mean_data_x0y0(2)/1000,'o','LineWidth',2);
plot(mean_data_x0y30(1)/1000,mean_data_x0y30(2)/1000,'o','LineWidth',2);
plot(mean_data_x0ym30(1)/1000,mean_data_x0ym30(2)/1000,'o','LineWidth',2);
plot(mean_data_x45y0(1)/1000,mean_data_x45y0(2)/1000,'o','LineWidth',2);
plot(mean_data_x45y30(1)/1000,mean_data_x45y30(2)/1000,'o','LineWidth',2);
plot(mean_data_x45ym30(1)/1000,mean_data_x45ym30(2)/1000,'o','LineWidth',2);
plot(mean_data_xm45y0(1)/1000,mean_data_xm45y0(2)/1000,'o','LineWidth',2);
plot(mean_data_xm45y30(1)/1000,mean_data_xm45y30(2)/1000,'o','LineWidth',2);
plot(mean_data_xm45ym30(1)/1000,mean_data_xm45ym30(2)/1000,'o','LineWidth',2);
xlim([-5 5]);
ylim([-3.5 3.5]);
hold off;

output = "vision_check/plot_ball_9point_before.pdf";
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
print(output,'-dpdf','-fillpage');