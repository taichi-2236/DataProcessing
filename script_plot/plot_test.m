%% plot_test.m

% theta = linspace(0,2*pi);
% x = 1/1 * cos(theta);
% y = theta .* (1/1 * sin(theta));
% x = 3/2 * cos(theta);
% y = 1/2 * sin(2*theta);

x0 = [ -4.0; 2.0; 0];

tg_x     = 3.0;
tg_y     = 0.5;
tg_angle = -pi/12;
tg_dir   = [ 1.0; 0.0 ];
% vx = pi/3;
t0 = 0.0;
tf = 10.0;
dt = 0.01;
T  = t0:dt:tf;

err_pre = 0;

v = 1.0;

if 1
    [t,value] = ode45(@(t,x) ...
                    [...
                        func_R(x(3))*w2r_vel(w_vel(t,x,dt),x(3));...
                        cmd_va(t,x,tg_angle);...
                    ],...
                    T,x0);
    
    figure(1)
    plot_field();
    hold on
    axis equal
    plot(value(:,1),value(:,2),'-',"LineWidth",2);
    
    xlim([-4.5 4.5]); ylim([-3.0 3.0]);
    % xticks([-2.0 -1.5 -1.0 -0.5 0.0 0.5 1.0 1.5 2.0]);
    % yticks([-2.0 -1.5 -1.0 -0.5 0.0 0.5 1.0 1.5 2.0]);
    legend("robot","Location","southeast");
    grid on
    hold off
    set(gca,'FontSize',20);
    set(gcf,'PaperOrientation','landscape');
    print("figure/sim_turnStrt_robot.pdf",'-dpdf','-fillpage');
    
    figure(2)
    hold on
    plot(t,value(:,3),'c-','LineWidth',2);
    % plot(t,omega(t),'r-','LineWidth',2);
    legend("angle","Location","southeast");
    grid on
    hold off
    set(gca,'FontSize',20);
    set(gcf,'PaperOrientation','landscape');
    print("figure/sim_turnStrt_angle.pdf",'-dpdf','-fillpage');
    
end

function U = w_vel(t, cmd, dt)
    % U(1,:) = 2*pi/10 * cos(2*pi / 10 * t);
    % U(2,:) = -2*pi/10 * sin(2*pi / 10 * t);
    % err = (1.0 - cmd(2));
    if (t > 8.0)
        U(1,:) = 0.0;
        U(2,:) = -1.0;
    elseif (t > 5.0)
        % U(2,:) = 1.0 * (sin(pi/12) - cmd(2));
        U(1,:) = pi/3 * cos(-(t-5.0)/6.0*pi);
        % U(2,:) = 2.0 * err;
        U(2,:) = pi/3 * sin(-(t-5.0)/6.0*pi);
    else
        U(1,:) = 1.0;
        U(2,:) = 0.0;
    end
end

function vx = cmd_vx(v, t, cmd, target, dir)
    V = w2r_vel(dir, cmd(3));
    vx = V(1);
end

function vy = cmd_vy(v, t, cmd, target, dir)
    V = w2r_vel(dir, cmd(3));
    vy = V(2);
end

function va = cmd_va(t, cmd, target)
    % if (cmd(1) > 0)
    if (t > 8.0)
        va = 0;
    elseif (t > 5.0)
        % va = pi/6 * (target - cmd(3));
        va = -pi/6.0;
        % va = pi/3 * (target - cmd(3));
    else
        va = 0;
    end
    % va = pi/4 * sin(4 * 2*pi / 10 * t) + 2*pi / 10;
end

function V = w2r_vel(U, theta)
    V = func_R(-theta) * U;
end