function [sigMat] = MYdelayGen(delayVec, sigMat)
% 入力された信号を所定の時刻，遅延させる関数
% 引数　delayVec：遅延量（列or行ベクトル），sigMat:遅延させる信号（列方向に時間）
% 　　　※delayVecの要素数とsigMatの列数が一致する必要あり。
%      ※先頭にdelayVec個の0を挿入して遅延を作る。
% 戻り値　sigMat:遅延させた信号（列方向に時間）
Nsig = length(delayVec); %遅延させる信号数
if Nsig~=length(sigMat(1,:))
    error('Error: MYdelayGen(): delayVecの要素数とsigMatの列数が一致しません。')
end
for co = 1:Nsig
    if delayVec(co)>0
        sigMat(delayVec(co)+1:end,co) = sigMat(1:(end-delayVec(co)),co);
        sigMat(1:(delayVec(co)),co) = zeros((delayVec(co)),1);
    end
end
end
