function num = setRoiNum
% Author: Jianpan Huang   Email: jianpanhuang@outlook.com
%
% FUNCTION:
%           Set ROI number                
% OUTPUT:                                          
%           num: ROI number 

%%
dlgTitle=['Set ROI number'];
prompt={['Please set the ROI number in this slice:']};
numLine=[1 60];
defaultAnswer={'1'};
options.Resize='on';
answer=inputdlg(prompt,dlgTitle,numLine,defaultAnswer,options);
num = str2double(answer{1});