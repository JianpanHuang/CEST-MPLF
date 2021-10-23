function y = zSpecLorentzDecomp(p, x, pn)
% Author: Jianpan Huang   Email: jianpanhuang@outlook.com
% FUNCTION:
%           Z-spectrum decomposition using (multi-pool) Lorentzian function
% INPUT:
%           p: Lorentzian parameters
%           x: frequency offsets
%           pn: pool number
% OUTPUT:
%           y: Z-spectrum and CEST curves of different pools

if nargin < 3
    pn = 4;
end

if pn==1
    y(:,1) = lorentzian1pool(p, x);
    y(:,2) = p(1); % Zi
elseif pn==2
    y(:,1) = lorentzian2pool(p, x); % All
    y(:,2) = lorentzian1pool(p(1:4), x); % Pool 1
    y(:,3) = lorentzian1pool([p(1),p(5:6),p(4)+p(7)], x); % Pool 2
    y(:,4) = p(1); % Zi
elseif pn==3
    y(:,1) = lorentzian3pool(p, x); % All
    y(:,2) = lorentzian1pool(p(1:4), x); % Pool 1
    y(:,3) = lorentzian1pool([p(1),p(5:6),p(4)+p(7)], x); % Pool 2
    y(:,4) = lorentzian1pool([p(1),p(8:9),p(4)+p(10)], x); % Pool 3
    y(:,5) = p(1); % Zi
elseif pn==4
    y(:,1) = lorentzian4pool(p, x); % All
    y(:,2) = lorentzian1pool(p(1:4), x); % Pool 1
    y(:,3) = lorentzian1pool([p(1),p(5:6),p(4)+p(7)], x); % Pool 2
    y(:,4) = lorentzian1pool([p(1),p(8:9),p(4)+p(10)], x); % Pool 3
    y(:,5) = lorentzian1pool([p(1),p(11:12),p(4)+p(13)], x); % Pool 4
    y(:,6) = p(1); % Zi
elseif pn==5
    y(:,1) = lorentzian5pool(p, x); % All
    y(:,2) = lorentzian1pool(p(1:4), x); % Pool 1
    y(:,3) = lorentzian1pool([p(1),p(5:6),p(4)+p(7)], x); % Pool 2
    y(:,4) = lorentzian1pool([p(1),p(8:9),p(4)+p(10)], x); % Pool 3
    y(:,5) = lorentzian1pool([p(1),p(11:12),p(4)+p(13)], x); % Pool 4
    y(:,6) = lorentzian1pool([p(1),p(14:15),p(4)+p(16)], x); % Pool 5
    y(:,7) = p(1); % Zi
elseif pn==6
    y(:,1) = lorentzian6pool(p, x); % All
    y(:,2) = lorentzian1pool(p(1:4), x); % Pool 1
    y(:,3) = lorentzian1pool([p(1),p(5:6),p(4)+p(7)], x); % Pool 2
    y(:,4) = lorentzian1pool([p(1),p(8:9),p(4)+p(10)], x); % Pool 3
    y(:,5) = lorentzian1pool([p(1),p(11:12),p(4)+p(13)], x); % Pool 4
    y(:,6) = lorentzian1pool([p(1),p(14:15),p(4)+p(16)], x); % Pool 5
    y(:,7) = lorentzian1pool([p(1),p(17:18),p(4)+p(19)], x); % Pool 6
    y(:,8) = p(1); % Zi
elseif pn==7
    y(:,1) = lorentzian7pool(p, x); % All
    y(:,2) = lorentzian1pool(p(1:4), x); % Pool 1
    y(:,3) = lorentzian1pool([p(1),p(5:6),p(4)+p(7)], x); % Pool 2
    y(:,4) = lorentzian1pool([p(1),p(8:9),p(4)+p(10)], x); % Pool 3
    y(:,5) = lorentzian1pool([p(1),p(11:12),p(4)+p(13)], x); % Pool 4
    y(:,6) = lorentzian1pool([p(1),p(14:15),p(4)+p(16)], x); % Pool 5
    y(:,7) = lorentzian1pool([p(1),p(17:18),p(4)+p(19)], x); % Pool 6
    y(:,8) = lorentzian1pool([p(1),p(20:21),p(4)+p(22)], x); % Pool 7
    y(:,9) = p(1); % Zi
end
