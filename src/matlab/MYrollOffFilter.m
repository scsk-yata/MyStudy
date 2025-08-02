function[rollOffFilterOut] = MYrollOffFilter(Ntap,Oversampling,alpha,filterInput)
% floorはその値以下の整数値に丸める
n = ( -floor(Ntap/2):(-floor(Ntap/2)+Ntap-1) ).';
N = 1/Oversampling;
A = sin(pi*n*N) ./(pi*n*N);
B1 = cos(alpha*pi*n*N);
B2 = 1-(2*alpha*pi*n*N).^2;
B2(B2==0) = 1e-10;
B = B1./B2;
h = A.*B;
h(n==0) = 1;
rollOffFilterOut = MYtdl(filterInput,Oversampling,h,Ntap);
return