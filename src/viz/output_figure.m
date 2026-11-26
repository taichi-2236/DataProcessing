%% output_figure
% データファイル名に合わせて指定ディレクトリにタグを付けてPDFグラフを保存する関数
%
% 引数:
%   datafile : 元データのファイルパスまたは名前
%   dir      : 保存先ディレクトリ（省略時は output/figure）
%   tag      : ファイル名の先頭につけるタグ
%   cropflag : 余白削除するかのフラグ（デフォルト true）
function output = output_figure(datafile, dir, tag, cropflag)
    arguments
        datafile (1,1) string
        dir      (1,1) string  = ""
        tag      (1,1) string  = ""
        cropflag (1,1) logical = true
    end

    if dir == ""
        dir = Constants.FileParam().OutputFigureDir;
    end
    if ~isfolder(dir)
        mkdir(dir);
    end

    [~, name, ~] = fileparts(datafile);
    cleanName = regexprep(name, "^\w*_data_", "");
    output = string(fullfile(dir, append(tag, cleanName, ".pdf")));

    if cropflag
        exportgraphics(gca, output);
    else
        print(output, '-dpdf', '-fillpage');
    end
    disp("PlotOut : " + output);
end
