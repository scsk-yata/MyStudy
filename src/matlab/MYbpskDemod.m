function[demodData] = MYbpskDemod(r)
demodData = ones(size(r));
demodData(real(r)<0) = 0;
return