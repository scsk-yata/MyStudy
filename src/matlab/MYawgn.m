function [n] = MYawgn(Pn,rn,cn)
% ���fAWGN������
% [n] = MYawgn(SNRdB,rn,cn)
% �����@Pn:�G���d�́Crn:�s���Ccn:��
% �߂�l n�irn�~cn�j
n=(randn(rn,cn) + 1j*randn(rn,cn))*sqrt(Pn/2);
end
