%% plot_err_traj2ball
% 目標経路とボールとの誤差の時間変化

%%% 1. 初期化処理
% close all

% err_CMD = sqrt(q_b(:,1).^2+q_b(:,2).^2) - 1.0 * ones(size(q_b,1),1);
% err_FB  = sqrt(q_b(:,1).^2+q_b(:,2).^2) - 1.0 * ones(size(q_b,1),1);
% T = transpose(1:size(q_b,1));
T = 1:1800;

figure
grid on;
hold on;
plot([0.0 30], [0.0 0.0], '--', "LineWidth", 1, "Color", '#080808');
plot(T/60, err_CMD(1:1800), '-', 'LineWidth', 2, 'Color', '#0000ff');
plot(T/60, err_FB(1:1800), '-', 'LineWidth', 2, 'Color', '#ff0000');
xlabel("time (s)")
ylabel("error (m)");
ylim([-0.15 0.06])
legend('reference path for ball', "Conventional method", "Proposed method", 'Location', 'northwest');
hold off

set(gca,'FontSize',28);
set(gcf,'PaperOrientation','landscape');
% output_figure(datafile, "figure\", "track_");
print("figure/errTraj2Ball_CMD_FB_NoN11_2.pdf",'-dpdf','-fillpage');
% exportgraphics(gcf,"figure/crop_errTraj2Ball_CMD_FB_NoN11.pdf");