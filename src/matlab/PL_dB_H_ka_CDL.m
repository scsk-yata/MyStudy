%% CDLチャネルモデルにおける1ユーザごとのチャネル応答を計算
function [PL_dB,H_ka] = PL_dB_H_ka_CDL(d_tu,hor_tu)

frequency = 5.2*10^9;
N_subcar = 288;
ple_LOS = 2.20;
ple_NLOS = 3.67;
d_LOS = 36;
N_user = 1;               % UEの数

P_LOS = min( 18/d_tu,1 )*(1-exp(-d_tu/d_LOS))+exp(-d_tu/d_LOS);

Num_of_Antennas_hor = 16;
Num_of_Antennas_ver = 8;
N_Antenna           = Num_of_Antennas_hor * Num_of_Antennas_ver;
K                   = 9.0;           % RicianのKファクター


















%% LOSの場合

if P_LOS > rand
    
    PL_dB = 28.0 + ple_LOS*10*log10(d_tu) + 20*log10(frequency/(10^9));
    
% パラメータ設定
DelayProfile = 'CDL-D';

% ループする前にメモリを確保
%H_k          = zeros(Num_of_UEs, Num_of_Antennas, Num_of_Subcarriers);        % H_k(:,:,k) ... k番目のサブキャリアにおけるチャネル行列
H_k_raw      = zeros(N_Antenna, N_subcar);        % H_k(:,:,k) ... k番目のサブキャリアにおけるチャネル行列
%Channel_all_antenna = zeros(N_user,N_subcar);


%% チャネル生成：CDLチャネル
cdl = nrCDLChannel;

cdl.DelayProfile = DelayProfile;

cdl.AngleScaling = false;
if cdl.AngleScaling
    cdl.AngleSpreads = [5.0 11.0 3.0 3.0];
    cdl.MeanAngles   = [0.0 0.0 0.0 0.0];
end

cdl.DelaySpread = 300e-9;          % 300 ns%%%%%%%%%%%%%%%%%%%

cdl.CarrierFrequency = 5.2*10^9;     % 5.2 GHz%%%%%%%%%%%%%%%%%%%%%%

cdl.MaximumDopplerShift = 5;     % 5 Hz

cdl.UTDirectionOfTravel = [0; 90];

if cdl.DelayProfile == 'CDL-D'
    cdl.KFactorScaling = false;
    if cdl.KFactorScaling
        cdl.KFactor        = K;
    end
end

% cle.KFactorScaling = false;

cdl.SampleRate          = 30.72e6;   % 30.72 MHz

cdl.TransmitAntennaArray.Size               = [Num_of_Antennas_hor Num_of_Antennas_ver 1 1 1];
cdl.TransmitAntennaArray.ElementSpacing     = [0.5 0.5 1.0 1.0];
cdl.TransmitAntennaArray.PolarizationAngles = [45 -45];

cdl.TransmitAntennaArray.Orientation        = [hor_tu-90; 0; 0];  % -90から90

cdl.TransmitAntennaArray.Element            = '38.901';
cdl.TransmitAntennaArray.PlarizationModel   = 'Model-2';

cdl.ReceiveAntennaArray.Size               = [N_user 1 1 1 1]; %%%%%%%%%%%%%%%%%%%%%%%%% 1
cdl.ReceiveAntennaArray.ElementSpacing     = [0.5 0.5 0.5 0.5];
cdl.ReceiveAntennaArray.PolarizationAngles = [0 90];
cdl.ReceiveAntennaArray.Orientation        = [0; 0; 0];
cdl.ReceiveAntennaArray.Element            = 'isotropic';
cdl.ReceiveAntennaArray.PlarizationModel   = 'Model-2';

cdl.SampleDensity = 64;

cdl.NormalizePathGains = true;

cdl.InitialTime = 0.0;      % 0.0 s

% cdl.NumStrongestClusters = 0;

cdl.RandomStream = 'mt19937ar with seed';

cdl.Seed = 73;

cdl.ChannelFiltering = true;

% cdl.NumTimeSamples = 30720;

cdl.NormalizeChannelOutputs = true;


cdlinfo = info(cdl);

%%
Impulse_in_freq_domain = ones(N_subcar, 1);
Impulse = ifft(Impulse_in_freq_domain) * sqrt(N_subcar);

N_Antenna = cdlinfo.NumTransmitAntennas;
H_temp = zeros(N_subcar, N_Antenna); % あるサブキャリアでの, 対象のユーザと128素子のアンテナとのチャネル応答

%
for Antenna_index = 1:N_Antenna
    Tx_Signal = zeros(N_subcar, N_Antenna);
    
     Tx_Signal(:,Antenna_index) = Impulse;
    %Tx_Signal(:,Antenna_index) = Inpulse * exp(1j*2*pi*rand);
    
    Rx_Signal = cdl(Tx_Signal);
    
    H_temp(:,Antenna_index) = fft(Rx_Signal) / sqrt(N_subcar);

end

%{
for Subcarrier_index = 1:N_subcar
    H_k_raw(:,Subcarrier_index) = H_temp(Subcarrier_index,:);   % 1ユーザ,各アンテナ,各サブキャリア
end

H_Power = mean(mean(abs(H_k_raw).^2));
%}
H_Power = mean(mean(abs(H_temp).^2));

H_ka = H_temp / sqrt(H_Power);      % 1ユーザ,各サブキャリア,各アンテナ





































%% NLOSの場合

else
    
    PL_dB = 22.7 + ple_NLOS*10*log10(d_tu) + 26*log10(frequency/(10^9));      % 距離はm単位で良い
% パラメータ設定
DelayProfile = 'CDL-A';

% ループする前にメモリを確保
%H_k          = zeros(Num_of_UEs, Num_of_Antennas, Num_of_Subcarriers);        % H_k(:,:,k) ... k番目のサブキャリアにおけるチャネル行列
H_k_raw      = zeros(N_Antenna, N_subcar);        % H_k(:,:,k) ... k番目のサブキャリアにおけるチャネル行列




%% チャネル生成：CDLチャネル
cdl = nrCDLChannel;

cdl.DelayProfile = DelayProfile;

cdl.AngleScaling = false;
if cdl.AngleScaling
    cdl.AngleSpreads = [5.0 11.0 3.0 3.0];
    cdl.MeanAngles   = [0.0 0.0 0.0 0.0];
end

cdl.DelaySpread = 300e-9;   % 300 ns 100mになる

cdl.CarrierFrequency = 5.2*10^9;

cdl.MaximumDopplerShift = 5;   % 5 Hz

cdl.UTDirectionOfTravel = [0; 90];

if cdl.DelayProfile == 'CDL-D'
    cdl.KFactorScaling = false;
    if cdl.KFactorScaling
        cdl.KFactor        = K;
    end
end

% cle.KFactorScaling = false;

cdl.SampleRate          = 30.72e6;   % 30.72 MHz

cdl.TransmitAntennaArray.Size               = [Num_of_Antennas_hor Num_of_Antennas_ver 1 1 1];
cdl.TransmitAntennaArray.ElementSpacing     = [0.5 0.5 1.0 1.0];
cdl.TransmitAntennaArray.PolarizationAngles = [45 -45];
cdl.TransmitAntennaArray.Orientation        = [hor_tu-90; 0; 0];
cdl.TransmitAntennaArray.Element            = '38.901';
cdl.TransmitAntennaArray.PlarizationModel   = 'Model-2';

cdl.ReceiveAntennaArray.Size               = [N_user 1 1 1 1];
cdl.ReceiveAntennaArray.ElementSpacing     = [0.5 0.5 0.5 0.5];
cdl.ReceiveAntennaArray.PolarizationAngles = [0 90];
cdl.ReceiveAntennaArray.Orientation        = [0; 0; 0];
cdl.ReceiveAntennaArray.Element            = 'isotropic';
cdl.ReceiveAntennaArray.PlarizationModel   = 'Model-2';

cdl.SampleDensity = 64;

cdl.NormalizePathGains = true;

cdl.InitialTime = 0.0;   % 0.0 s

% cdl.NumStrongestClusters = 0;

cdl.RandomStream = 'mt19937ar with seed';

cdl.Seed = 73;

cdl.ChannelFiltering = true;

% cdl.NumTimeSamples = 30720;

cdl.NormalizeChannelOutputs = true;



cdlinfo = info(cdl);

Impulse_in_freq_domain = ones(N_subcar, 1);
Impulse = ifft(Impulse_in_freq_domain) * sqrt(N_subcar);

N_Antenna = cdlinfo.NumTransmitAntennas;

H_temp = zeros(N_subcar, N_Antenna);

%
for Antenna_index = 1:N_Antenna
    Tx_Signal = zeros(N_subcar, N_Antenna);
    
     Tx_Signal(:,Antenna_index) = Impulse;
%    Tx_Signal(:,Antenna_index) = Inpulse * exp(1j*2*pi*rand);
    
    Rx_Signal = cdl(Tx_Signal);
    
    H_temp(:,Antenna_index) = fft(Rx_Signal) / sqrt(N_subcar);

end

%{
for Subcarrier_index = 1:N_subcar
    H_k_raw(:,Subcarrier_index) = H_temp(Subcarrier_index,:);
end
%}
H_Power = mean(mean(abs(H_temp).^2));       % 全アンテナ素子, 全サブキャリアの場合の平均電力

H_ka = H_temp / sqrt(H_Power);    % チャネル応答の絶対値の2乗の全平均を1にしたい



end

end