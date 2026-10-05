function edge_idxs = find_discontinuous_idx(data)
	edge_idxs = [];
	start     = 1;
	finish    = max(size(data));
	for k = 2:finish
		if data(k) - data(k-1) > 1
			edge_idxs = [edge_idxs; [start,k-1]];
			start = k;
		end
	end
	if start < finish
		edge_idxs = [edge_idxs; [start,finish]];
	end
end
