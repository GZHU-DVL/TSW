%%PSNR
function PSNR = psnr(f1, f2)
k = 8; 
fmax = 2.^k - 1; 
a = fmax.^2;
e = double(f1) - double(f2);
[m, n] = size(e);
b = sum(sum(e.^2)); 
PSNR = 10*log10(m*n*a/b);