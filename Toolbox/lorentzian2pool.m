function y = lorentzian2pool(p, x)
% Two-pool Lorentzian function
% Jianpan Huang   Email: jianpanhuang@outlook.com

	y = p(1) - p(2)*(p(3)/2)^2./((p(3)/2)^2+(x-p(4)).^2)... 
             - p(5)*(p(6)/2)^2./((p(6)/2)^2+(x-p(4)-p(7)).^2);