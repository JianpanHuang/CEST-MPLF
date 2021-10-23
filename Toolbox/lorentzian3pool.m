function y = lorentzian3pool(p, x)
% Three-pool Lorentzian function
% Jianpan Huang   Email: jianpanhuang@outlook.com

	y = p(1) - p(2)*(p(3)/2)^2./((p(3)/2)^2+(x-p(4)).^2)... 
             - p(5)*(p(6)/2)^2./((p(6)/2)^2+(x-p(4)-p(7)).^2)...
             - p(8)*(p(9)/2)^2./((p(9)/2)^2+(x-p(4)-p(10)).^2);