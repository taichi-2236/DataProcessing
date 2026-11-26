datafile = "data/robot_data_StrtP_phase_targetx1500y1500_KpP1000G300F200_KaPPI4GPI6FPI4_maxwPI4_No11.dat";
% datafile = "data/robot_data_StrtP_onlyPush_KpP1000_KaPPI4_maxwPI4_No11.dat";
data = load(datafile,'-ascii');

idx = 9;
sz = size(data);

pre_value = -data(1,idx);
value = -data(1,idx);
max_diff = 0;
max_diff_idx = 0;
diff = zeros(sz(1)-1,1);
for i = 2:sz(1)
    value = -data(i,idx);
    diff(i-1,1) = value - pre_value;
    % if -data(i,8) < -4.0
    %     disp(i);
    %     pre_value = value;
    %     continue;
    % end
    % if value > -1.5
    %     fprintf('break idx = %d\n', i);
    %     break;
    % end
    if max_diff < value - pre_value
        max_diff = value - pre_value;
        max_diff_idx = i;
    end
    pre_value = value;
end

fprintf('max_diff = %f\n', max_diff);
fprintf('max_diff_idx = %d\n', max_diff_idx);