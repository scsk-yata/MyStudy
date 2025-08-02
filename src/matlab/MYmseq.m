function[c] = MYmseq(w)
% wが疑似乱数生成のための重み
D = length(w);
Mseq_length = 2^D-1;
mem = ones(D,1);
c = zeros(Mseq_length,1);
for x = 1:Mseq_length
    c(x) = mem(end);
    h0 = mod(w' * mem,2);
    mem(2:end) = mem(1:(end-1));
    mem(1) = h0;
end
c(c==0) = -1;
return