%% find_discontinuous_idx
% 連続する整数インデックス列の不連続箇所を検出し、[開始index, 終了index] の組を返す関数
function edge_idxs = find_discontinuous_idx(data)
    edge_idxs = [];
    if isempty(data)
        return;
    end

    start  = 1;
    finish = numel(data);
    for k = 2:finish
        if data(k) - data(k-1) > 1
            edge_idxs = [edge_idxs; [start, k-1]]; %#ok<AGROW>
            start = k;
        end
    end
    edge_idxs = [edge_idxs; [start, finish]];
end
