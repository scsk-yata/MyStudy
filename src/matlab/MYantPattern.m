function[doa,antPat_dB] = MYantPattern(N_R,w,d)
% A_antPatは(受信アンテナ数×到来パス数)
% 線形アダプティブアレーアンテナのアンテナパターン計算
% 引数　N_R: アンテナ本数，w: アンテナ重み係数（N_R×1），
% 　　　d: 波長で正規化したアンテナ間隔（1×1）
% 戻り値　doa: アンテナパターンを計算した角度，antPat_dB: 正規化アンテナパターン [dB]
doa = -90:90;
A_antPat = MYsteer(N_R,d,doa);
P_theta_dB = 10*log10(abs(w' * A_antPat).^2);
antPat_dB = P_theta_dB - max(P_theta_dB);
return