function[TDLout] = MYtdl(filterInput,overSampling,h,Ntap)
% OverSamplingはインパルス周期とサンプリング周期の比
Ndata = length(filterInput);
outputLength = Ntap + (Ndata-1) * overSampling;
TDLout = zeros(outputLength,1);
for c = 1:Ndata
    START = 1+(c-1)*overSampling; %パルス入力系列はOverSampling間隔で入力される
    END = START+Ntap-1;
    TDLout(START:END) = TDLout(START:END) + h*filterInput(c);
end
return