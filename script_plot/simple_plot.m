close all
data = load("data/robot_data_StrtP_wPI12.dat",'-ascii');
data2 = load("data/robot_data_StrtP_phase_target1500_wPI12_No11.dat",'-ascii');

push_sign = sign(-data2(:,6).*(data2(:,8)-data2(:,5))+data2(:,5).*(data2(:,9)-data2(:,6)));
figure(1)
subplot(2,1,1)
plot(data(:,1)/60,data(:,6),'r-');
grid on
hold on
plot(data2(:,1)/60,data2(:,6),'b-');
plot(data2(:,1)/60,data2(:,9)+78*sin(push_sign*pi/12),'k-');
plot(data2(:,1)/60,data2(:,9),'m-');
xlabel('time[sec]');
ylabel('position y [mm]');
legend('姿勢制御','姿勢制御＋軌道追従制御', 'Location','east');
hold off
subplot(2,1,2)
plot(data2(:,1)/60,push_sign.*sign(200-abs(data2(:,9))),'-');
hold on
grid on
% plot(data2(:,1)/60,-data2(:,6).*(data2(:,8)-data2(:,5))+data2(:,5).*(data2(:,9)-data2(:,6)),'-');
ylabel('y*の切り替え条件');
hold off
