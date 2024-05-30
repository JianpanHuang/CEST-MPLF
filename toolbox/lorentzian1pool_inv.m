function y = lorentzian1pool_inv(p, x)
% One-pool Lorentzian function
% Jianpan Huang   Email: jianpanhuang@outlook.com

y = p(1)*p(2)^2/4./(p(2)^2/4+(x-p(3)-p(4)).^2) ;