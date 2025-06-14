function[BERbpskTheory] = MYbpskTheoBER(SNRdB)
SNR = 10.^(SNRdB/10);
BERbpskTheory = erfc(sqrt(SNR))/2;
return