%% ��M�[�����p��,���ʊp�ƂɈʒu����ꍇ��,�d�ݍs��ɏ�Z����W���s����쐬����֐�

% a(��,��)�́i�c�����̑f�q���j�~�i�������̑f�q���j�T�C�Y�̍s��ł���, ���̍s��̊e�v�f��,
% �r�[���t�H�[�~���O�p�̏d�ݍs��̑Ή�����e�v�f�ɏ�Z����

function a = a_128_1(ang_hor,ang_ver)    % ���ʊp,�p

N_ver = 8;    % ���������̑f�q��
N_hor = 16;   % ���������̑f�q��
a = zeros(N_ver*N_hor,1);   % �d�ݍs��̃T�C�Y��ݒ�
c = 3e8;    % ����
frequency = 5.2e9;  % ���S���g��f 5.2 GHz���Ƃ��čl���Ă݂�
lambda = c/frequency;  % �g����
d = lambda/2;  % �f�q�ԋ���


for nx=1:N_hor
    for nz=1:N_ver
        %a((nz-1)*N_hor+nx,1) = exp(1j*2*pi*d/lambda*(nx*cosd(ang_hor)*sind(ang_ver)+nz*cosd(ang_ver)));
        a((nx-1)*N_ver+nz,1) = exp(1j*2*pi*d/lambda*(nx*cosd(ang_hor)*sind(ang_ver)+nz*cosd(ang_ver)));
    end
end

end