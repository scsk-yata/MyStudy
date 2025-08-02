%% スナップショット Rayleigh 分布
Np = 10;
Nsnap = 100000;

randPhase = rand(Np,Nsnap) * 2*pi;
signalMat = exp(1i*randPhase);
rxSignal = sum(signalMat); % 1×Nsnapのベクトル
rxSignalAmp = abs(rxSignal);

x = 0:0.1:50;
%[derivedPDF,binPosi] = hist(rxSignalAmp,x);
sigma2 = mean(real(rxSignal).^2);
p_x = x/sigma2 .* exp(-(x.^2)/2/sigma2); % Theoretical Value

figure
axis([0 10 0 0.3])
%plot(x,p_x,x,derivedPDF/max(derivedPDF)*max(p_x))
%histogramの場合，derivedPDFをmaxの引数にできない
%derivedPDF = histogram(rxSignalAmp,x);
derivedPDF = histogram(rxSignalAmp,x,'Normalization','pdf'); % 確率密度となるように正規化させる
hold on
plot(x,p_x)