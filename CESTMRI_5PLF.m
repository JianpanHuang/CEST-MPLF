% CEST MRI analysis using 5-pool Lorentzian fitting (5PLF, might not be suitable for CEST data acquired at low fields)  
% Jianpan Huang, Email: jianpanhuang@outlook.com
clear all, close all, clc;
addpath(genpath(pwd));

%% Load data
dataPath = [pwd, filesep, 'Data']; % Set to current 'Data' path or anywhere defined by user as: dataPath = '/Users/...';
load([dataPath, filesep, 'MouseBrain.mat'])
[xn, yn, wn] = size(zImg);
zImgNorm = zImg./repmat(m0Img, [1,1,wn]); % Normalize to M0 image

%% Calculate the averaged Z-spectrum in ROI
% [mask, num] = drawRoi(m0Img, dataPath, roiName);
mask = brainMask;
z=zeros(wn,1);
for m = 1:wn
    imgTemp = zImgNorm(:,:,m);
    z(m,1) = mean2(imgTemp(mask==1));
end

%% Fit the averaged Z-spectrum
pn = 5; % pool number
%             1. Water              2. Amide               3. NOE                 4. MT                  5. Amine
%      Zi     A1    G1    dw1       A2     G2    dw2       A3     G3    dw3       A4     G4    dw4       A5     G5    dw5
lb = [ 1      0.4   1.0   -1.0      0.0    1.0   3.5       0.0    2.0   -3.5      0.001  30    -2.5      0.0    1.0   2.0];
iv = [ 1      0.9   2.3   0         0.0    2.0   3.5       0.1    4.0   -3.5      0.1    60    -2.5      0.0    2.0   2.0];
ub = [ 1      1     6.0   +1.0      0.2    10.0  3.5       0.2    12.5  -3.5      0.3    100   -2.5      0.2    10.0  2.0];
par = lsqcurvefit(@lorentzian5pool,iv,offs,z,lb,ub); % Fitted parameters
res = zSpecLorentzDecomp(par, offs, pn); % Fitted results
zFit = res(:,1);
water = res(:,2);
amide = res(:,3);
noe = res(:,4);
mt = res(:,5);
amine = res(:,6);

%% Plot the averaged results
figure, plot(offs, z, 'bo', offs, zFit, 'b-',...
             offs, water, 'r-.', offs, amide, 'g-.',...
             offs, noe, 'c-.', offs, mt, 'm-.', offs, amine, 'k-.', 'LineWidth',1.5);
% axis([-10,10,0,1.02]);
axis([min(offs(:)),max(offs(:)),0,1.01]); 
xlabel('Offset (ppm)'); ylabel('Z (%)');
title('Z spectrum'); 
legend('Z', 'Z_f_i_t', 'Water', 'Amide', 'NOE', 'MT', 'Amine', 'Location', 'southeast');
set(gca, 'Xdir', 'reverse', 'FontWeight', 'bold', 'FontSize', 14)

%% Decide whether to obtain CEST maps
answ = questdlg('Do you want to get CEST maps?', ...
    'Decision on CEST maps', ...
    'No','Yes','No');
switch answ
    case 'Yes'
        CESTMRI_5PLF_Map;
    case 'No'
        disp('CEST processing is done!')
end
