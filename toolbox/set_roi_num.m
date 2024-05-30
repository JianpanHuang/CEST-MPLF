function num = set_roi_num
% FUNCTION:
%	Set ROI number                
% OUTPUT:                                          
%	num: ROI number 
% AUTHOR:
% Jianpan Huang, Email: jianpanhuang@outlook.com

%%
dlgTitle= 'ROI number' ;
prompt={'Please define ROI number:'};
numLine=[1 60];
defaultAnswer={'1'};
options.Resize='on';
answer=inputdlg(prompt,dlgTitle,numLine,defaultAnswer,options);
num = str2double(answer{1});