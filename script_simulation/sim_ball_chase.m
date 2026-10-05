init_ball_point  = [0,500];
init_robot_point = [0,0];

init_ball_vel  = [500,0];
init_robot_vel = [0,0];

t0 = 0.0;
tf = 10.0;
dt = 0.01;
T  = t0:dt:tf;

x0 = [0;500;-100];

[t,value] = ode45(@(t,x) ...
											[ ...
												x0(2) + x(3)*t; ...
												x0(3) + x(3); ...
												10 ...
											], ...
										T,x0);

figure(1)
grid on;
hold on;
plot(t,value(:,2))
hold off;