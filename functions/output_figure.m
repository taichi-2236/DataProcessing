% /** 
%  * データファイル名に合わせて指定ディレクトリにタグを付けてグラフを保存する
%  * @param datafile ファイルパス
%  * @param dir      保存先のディレクトリ
%  * @param tag      ファイル名の先頭につけるタグ
%  */
function output_figure(datafile,dir,tag)
    if nargin < 2 || isempty(dir)
        dir = '';
    end
    if nargin < 3 || isempty(tag)
        tag = '';
    end
    [~,name,~] = fileparts(datafile);
    output = append(dir,tag,regexprep(name,"\w*_data_",""),".pdf");
    print(output,'-dpdf','-fillpage');
    disp("PlotOut : "+output);
end
