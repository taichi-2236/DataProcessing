%% format_mcap_topics
% 指定されたmcapのtopicsからコマンドオプション文字列とファイル名タグを生成する関数
%
% 引数:
%   topics : mcapから抽出するtopicsを列挙したcell配列またはstring配列（空の場合は全トピック）
function [topics_opt, topics_tag] = format_mcap_topics(topics)
    if nargin < 1 || isempty(topics)
        topics_opt = "";
        topics_tag = "";
        return;
    end

    topics_opt = "";
    topics_tag = "";

    n = numel(topics);
    for i = 1:n
        if topics_opt ~= ""
            topics_opt = append(topics_opt, ",");
        end

        topicName = string(topics{i});
        switch topicName
            case "aggregated_svgs"
                topics_opt = append(topics_opt, "/aggregated_svgs");
                topics_tag = append(topics_tag, "_svgs");

            case "vision"
                topics_opt = append(topics_opt, "/vision");
                topics_tag = append(topics_tag, "_vision");

            case "referee"
                topics_opt = append(topics_opt, "/referee");
                topics_tag = append(topics_tag, "_ref");

            case "return_packet"
                topics_opt = append(topics_opt, "/return_packet");
                topics_tag = append(topics_tag, "_repack");

            case "target_state"
                topics_opt = append(topics_opt, "/target_state");
                topics_tag = append(topics_tag, "_tgstat");

            case "obstacle"
                topics_opt = append(topics_opt, "/obstacle");
                topics_tag = append(topics_tag, "_obs");

            otherwise
                error('入力されたトピック "%s" は未定義です．', topicName);
        end
    end
end
