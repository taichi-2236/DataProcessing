%% calc_field_resist

% # 初期化
close all;
if(exist('auto','var') < 1)
    clear; 
    datafile = "ball_speed_data/ball_speed_data_No1_NoN11_3-8.dat";
end

% # データ取得
data = load(datafile, '-ascii');

t_idx = 1;
bx_idx = 2;
bvx_idx = 4;
bvy_idx = 5;

sz = size(data);

row_start  = 1;
% row_start  = 800;
row_finish = sz(1); 
% row_finish = 5750;

% # データ整形（閾値以下の値と直前の値と差が大きい値を削除）
% for k = 1:15
%     pre_data = data(row_start,bvx_idx);
%     cal_data = data(row_start,bvx_idx);
%     for i = row_start+1:row_finish
%         cal_data = data(i,bvx_idx);
%         if abs(pre_data - cal_data) > 120 || abs(cal_data) < 500
%             data(i,bvx_idx) = 0;
%         end
%         pre_data = cal_data;
%     end
% end
 
% pre_value = data(row_start,bvx_idx);
% start_idx = 0;
% finish_idx = 0;
% count = 0;
% mu_tmp = zeros(200);
% for i = row_start+1:row_finish
%     value = data(i,bvx_idx);
%     if pre_value == 0 && value ~= 0
%         start_idx = i;
%     end
%     if pre_value ~= 0 && value == 0 && start_idx > 0 && start_idx + 10 < i
%         finish_idx = i-1;
        
%         % ## 摩擦係数を計算
%         x = data(start_idx:finish_idx,t_idx);
%         y = data(start_idx:finish_idx,bvx_idx);
%         sz2 = size(x);
%         [x,y_fit] = LSM_1D(x,y);
%         tmp = fieldResist(y_fit(1)/1000,y_fit(sz2(1))/1000,abs(data(data(:,t_idx)==x(1),bx_idx) - data(data(:,t_idx)==x(sz2(1)),bx_idx))/1000);
%         if tmp >= 0.1
%             pre_value = value;
%             continue;
%         end
%         count = count + 1;
%         mu_tmp(count) = tmp;
%         clear x;
%         clear y;
%     end
%     pre_value = value;
% end
% mu = mu_tmp(mu_tmp(:)~=0);
% if count==0
    % mu = 0;
% end
% mu_mean = mean(mu);
% fprintf("count = %d, mu_mean = %f\n", count, mu_mean);

% # 図の表示
figure(1)
grid on;
hold on;
plot(data(row_start:row_finish,t_idx),data(row_start:row_finish,bvx_idx),'o-',"LineWidth",2);
% plot(x,y_fit,'-',"LineWidth",1);
xlabel("time(s)");
ylabel("x velocity(mm/s)");
legend("ball\_vel.x","Location","northeast");
% legend("ball\_vel.x","polyfit","Location","northeast");
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
hold off;

% output_figure(datafile,"figure/","format_");

% figure(2)
% grid on;
% hold on;
% if count > 0
%     plot(transpose(linspace(1,count,count)),mu,'x',"LineWidth",2);
% end
% plot([1 count],[mu_mean mu_mean],"Color",'#ff9900');
% ylabel("\mu");
% legend("\mu","\mu\_mean","Location","northeast");
% set(gca,'FontSize',20);
% set(gcf,'PaperOrientation','landscape');
% hold off;

function mu = fieldResist(v1,v2,l)
    ga = 9.80665;
    mu = (7 * (v1^2 - v2^2))/(10 * ga * l);
end
