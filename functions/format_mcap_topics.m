%% format_mcap_topics
% 指定されたmcapのtopicsからオプションとタグを生成する関数

%%% 1. 引数
% * *topics* mcapから抽出するtopicsを文字列で列挙したcell配列
function [topics_opt, topics_tag] = format_mcap_topics(topics)
	% 初期化
	topics_opt = "";
	topics_tag = "";

	% 指定されたtopicsの分ループ
	n = max(size(topics));
	for i = 1:n
		% オプション区切り処理
		if topics_opt ~= ""
			topics_opt = append(topics_opt,',');
		end

		% topicsを識別
		switch string(topics(i))
			case 'aggregated_svgs'
				topics_opt = append(topics_opt, '/aggregated_svgs');
				topics_tag = append(topics_tag, '_svgs');

			case 'vision'
				topics_opt = append(topics_opt, '/vision');
				topics_tag = append(topics_tag, '_vision');

			case 'referee'
				topics_opt = append(topics_opt, '/referee');
				topics_tag = append(topics_tag, '_ref');

			case 'return_packet'
				topics_opt = append(topics_opt, '/return_packet');
				topics_tag = append(topics_tag, '_repack');

			case 'target_state'
				topics_opt = append(topics_opt, '/target_state');
				topics_tag = append(topics_tag, '_tgstat');

			case 'obstacle'
				topics_opt = append(topics_opt, '/obstacle');
				topics_tag = append(topics_tag, '_obs');

			% どのtopicsにも該当しなければエラー
			otherwise
				error('入力されたトピック"%s"は含まれていません．', string(topics(i)));
		end
end