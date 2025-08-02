%% ロールオフフィルタによって帯域制限したインパルスの出力
Ntap = 20;
n_tap = (-Ntap/2+1) : (Ntap/2);
Tsample = 1/4;
alpha = 0.5;
A = sin(pi*n_tap*Tsample) ./ (pi*n_tap*Tsample);
B1 = cos(alpha*pi*n_tap*Tsample);
B2 = 1-(2*alpha*n_tap*Tsample).^2;
B = B1./B2;
h = A.*B;
h(n_tap==0) = 1;

filterInput = [1,-1,1];
Nimpulse = length(filterInput);
Noutput = Ntap + (Nimpulse-1)/Tsample;
TDLout = zeros(1,Noutput);
for c = 1:Nimpulse
    START = 1+(c-1)/Tsample; %パルス入力系列はOverSampling間隔で入力される
    END = START + Ntap-1;
    TDLout(START:END) = TDLout(START:END) + h*filterInput(c);
end

figure
stem(TDLout)