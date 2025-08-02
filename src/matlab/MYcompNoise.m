function[noise] = MYcompNoise(noiseSize,Pn)
% noiseSizeは[ , ]で指定
noise = ( randn(noiseSize) + 1i*randn(noiseSize) ) * sqrt(Pn/2);
return