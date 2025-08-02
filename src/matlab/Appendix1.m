%% 保存されたテキストファイルからMatlabの変数として読み込むコード
fid = fopen('BER.txt');
readData = fscanf(fid,'%f',[2 inf]).' ;
fclose(fid);
% 