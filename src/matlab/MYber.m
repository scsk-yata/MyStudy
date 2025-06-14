function[BER] = MYber(demodData,correctData)
% function [BER] = MYber(data1,data2)
% BER測定
% [BER] = MYber(data1,data2)
% 引数　data1: 正しいデータ，data2: 誤りを含むデータ
% 　　　（どちらがどちらでもよい）
% 戻り値　BER: ビット誤り率
% BER = sum(abs(data1-data2))/length(data1);
% end
BER = sum(abs(demodData-correctData))/length(demodData);
return
