%% prot_orbit.m

% # ===== グラフ描画 =====

figure
legend_tag = [];

% ## フィールド描画
plot_field(); % フィールドを描画する場合はコメントアウトを外す

grid on
hold on

% ## 目標経路描画
plotTargetTrajection(); % 目標経路を描画する場合はコメントアウトを外す
legend_tag = [legend_tag, "reference path for ball"];

% ## ロボットの軌跡の描画
plot(q_r(:,1),q_r(:,2),'-','LineWidth',2,'Color','#007FFF');
legend_tag = [legend_tag, "robot"];

% ## ボールの軌跡の描画
plot(q_b(:,1),q_b(:,2),'-','LineWidth',2,'Color','#FF8F00');
legend_tag = [legend_tag, "ball"];

% ## 指定frame時のロボットとボールのイメージを描画
% frame_idxs = [1, 45];
% plotRobotAndBall(frame_idxs, q_r, q_b); % ロボットとボールのイメージを描画する場合はコメントアウトを外す

% ## グラフのプロパティを設定
xlabel('x (m)'); ylabel('y (m)');
axis equal
xlim([-2.0 2.0]); ylim([-2.0 2.0]);
% xticks([-4.0, -3.75, -3.5, -3.25, -3.0]);
% yticks([0.0, 0.25, 0.5, 0.75, 1.0]);
legend(legend_tag, "Location", "southeast");
hold off

% グラフを出力
set(gca,'FontSize',20);
set(gcf,'PaperOrientation','landscape');
output_figure(datafile, "figure\", "track_"); % グラフを出力する場合はコメントアウトを外す


% # ===== 関数定義 =====

% /**
%  * 目標経路を出力する関数
%  */
function plotTargetTrajection()
	CircleRadius = 1.0;
	theta = linspace(0,2*pi);
	plot(CircleRadius*cos(theta),CircleRadius*sin(theta),'r--','LineWidth',1);
	% plot(-data(1,20)/1000+tout/60*cos(data(1,19)),-data(1,21)/1000+tout/60*sin(data(1,19)),'-','LineWidth',1,'Color','#FF0000');
	% plot(-q_r(:,1),-2.0*ones(size(q_r(:,1))),'-','LineWidth',1,'Color','#FF0000');
end

% /**
%  * 指定frameにロボットとボールを描画する関数
%  * @param frame_idxs 指定frameの配列
%  * @param q_r        時系列ごとのロボットの座標と姿勢角
%  * @param q_b　      時系列ごとのボールの座標
%  */
function plotRobotAndBall(frame_idxs, q_r, q_b)
	marker_size = 18.0;
	sz = max(size(frame_idxs));
	for i = 1:sz
		p = plot(q_b(frame_idxs(i),1),q_b(frame_idxs(i),2),'Marker','o','MarkerFaceColor','#FF8F00','MarkerEdgeColor','#000000');
		p.MarkerSize = marker_size;
		sslrobot(q_r(frame_idxs(i),1),q_r(frame_idxs(i),2),q_r(frame_idxs(i),3));
		str = "t = " + round(frame_idxs(i)/60.0,3) + "s"; 
		txt = text(q_r(frame_idxs(i),1)-0.25,q_r(frame_idxs(i),2),str);
		fontsize(txt,15,"pixels");
	end
end