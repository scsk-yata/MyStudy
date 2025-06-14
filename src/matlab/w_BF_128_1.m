%% �p��,���ʊp�ƕ����փr�[���t�H�[�~���O���s�����߂̏d�ݍs����쐬����֐�

% w(��,��)�́i�c�����̑f�q���j�~�i�������̑f�q���j�T�C�Y�̍s��ł���, ���̍s��̊e�v�f��,�A���[�A���e�i
% �̊e�f�q���瑗�M����鑗�M�M��s(�c�����̔ԍ�,�������̔ԍ�)�ɏ�Z���邱�Ƃ�,�S�Ă̐M���𓯂������֋��߂邱�Ƃ��ł���

function W = w_BF_128_1(hor_angle,ver_angle)

N_ver = 8;    % ���������̑f�q��
N_hor = 16;   % ���������̑f�q��
W = zeros(N_ver*N_hor,1);   % �d�ݍs��̃T�C�Y��ݒ�
c = 3e8;    % ����
frequency = 5.2e9;  % ���S���g��f 5.2 GHz���Ƃ��čl���Ă݂�
lambda = c/frequency;  % �g����
d = lambda/2;  % �f�q�ԋ���

for nx=1:N_hor
    for nz=1:N_ver
        W((nx-1)*N_ver+nz,1) = exp(-1j*2*pi*(d/lambda)*(nx*cosd(hor_angle)*sind(ver_angle)+nz*cosd(ver_angle)));
        %W((nz-1)*N_hor+nx,1)=exp(-1j*2*pi*d/lambda*(nx*cosd(hor_angle)*sind(ver_angle)+nz*cosd(ver_angle)));
    end                      % �e�f�q�ʒu�ɑΉ�����d�݂𐶐�����
end

end