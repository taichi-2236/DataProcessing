% /** 
%  * データファイル名に合わせて指定ディレクトリにタグを付けてグラフを保存する
%  * @param datafile ファイルパス
%  * @param dir      保存先のディレクトリ
%  * @param tag      ファイル名の先頭につけるタグ
%  * @param cropflag 余白削除するかのフラグ（defaultはtrue）
%  */
function output_figure(datafile,dir,tag,cropflag)
    arguments
        datafile string
        dir      string  = ''
        tag      string  = ''
        cropflag logical = true
    end
    [~,name,~] = fileparts(datafile);
    output = append(dir,tag,regexprep(name,"\w*_data_",""),".pdf");
    if cropflag
        exportgraphics(gca, output);
    else
        print(output,'-dpdf','-fillpage');
    end
    disp("PlotOut : "+output);
end
