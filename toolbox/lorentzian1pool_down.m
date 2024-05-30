function y = lorentzian1pool_down(p, x)
% One-pool Lorentzian function
% Jianpan Huang   Email: jianpanhuang@outlook.com
	y = p(1) - (p(1) - p(2)*(p(3)/2)^2./((p(3)/2)^2+(x-p(4)).^2));