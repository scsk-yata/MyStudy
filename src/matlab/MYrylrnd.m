function [rS] = MYrylrnd(Pa, L)
% ���ϓd�͂�Pa�Ƃ��郌�C���[�����̐���
% �����@Pa: ���ϓd�́i1�~1�j�CL: �����̒����i1�~1�j
% �߂�l�@rS: ���C���[�����iL�~1�j
Npath = 20;
randPhase = rand(Npath,L) *2*pi;
s = exp(1j*randPhase)*sqrt(Pa/Npath);
rS = abs(sum(s).');
end
