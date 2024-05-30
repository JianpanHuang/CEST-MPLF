% CEST processing using multipool Lorentzian fitting (MPLF) (with inverse Z-spectrum analysis)
% Jianpan Huang - jianpanhuang@outlook.com, 20230818
clear all, close all, clc
addpath(genpath(pwd));

%% Load data
filepath = 'data';
load([filepath,filesep,'simu_phant_5pools_amidediff.mat']); % The mat file includes CEST images (img), frequency offsets (offs) and ROI (roi)
if length(size(img)) == 3
    img_temp = img;
    clear img;
    img(:,:,1,:) = img_temp;
end
% Seperate M0 and CEST images
img_m0 = img(:,:,:,1);
img(:,:,:,1) = [];
offs(1) = [];

%% Z-spectrum normalization
[xn, yn, sn, on] = size(img); % x, y, slice, offset
img_norm = img./repmat(img_m0, [1,1,1,on]);

%% Z-spectrum fitting
if ~exist([filepath, filesep, 'mplf.mat'],'file') == 1
    pn = 5; % pool number -- A(Guan) set to all zeros to use 4 pools, otherwise 5 pools, see below iv, lb and ub setting
    %             1. Water              2. Amide               3. rNOE                 4. MT                  5. Guan
    %      Zi     A1    G1    dw1       A2     G2    dw2       A3     G3    dw3       A4     G4    dw4       A5     G5    dw5
    iv = [ 1      0.9   2.3   0         0.01   2.0   3.5       0.01   4.0   -3.5      0.1    60    -2.5      0.0    2.0   2.0];
    lb = [ 1      0.4   1.0   -2.0      0.0    1.0   3.5       0.0    2.0   -3.5      0.001  30    -2.5      0.0    1.0   2.0];
    ub = [ 1      1     6.0   +2.0      0.25   12.5  3.5       0.25   15.0  -3.5      0.35   150   -2.5      0.0    12.5  2.0];
    db0 = zeros(xn, yn, sn);
    amide = zeros(xn, yn, sn);
    amide_inv = zeros(xn, yn, sn, on);
    rnoe = zeros(xn, yn, sn);
    rnoe_inv = zeros(xn, yn, sn, on);
    mt = zeros(xn, yn, sn);
    mt_inv = zeros(xn, yn, sn, on);
    guan = zeros(xn, yn, sn);
    guan_inv = zeros(xn, yn, sn, on);
    fit_para = zeros(xn, yn, sn, length(iv));
    roi_vec = roi(:);
    roi_vec(roi_vec==0) = [];
    roi_len = length(roi_vec);
    % figure(1);
    h = waitbar(0, 'Doing Lorentzian fitting voxel by voxel, please wait >>>>>>'); 
    set(h, 'Units', 'normalized', 'Position', [0.4, 0.2, 0.3, 0.08])
    count = 1;
    tic
    for s = 1:sn
        for m = 1:xn
            for n = 1:yn
                if roi(m,n,s) == 1
                    count = count+1;
                    zspec = squeeze(img_norm(m,n,s,:));
                    % fitted arameters
                    par = lsqcurvefit(@lorentzian5pool,iv,offs,zspec,lb,ub);
                    db0 = par(4);
                    % water(m,n,s) = par(2);
                    amide(m,n,s) = par(5);
                    rnoe(m,n,s) = par(8);
                    mt(m,n,s) = par(11);
                    guan(m,n,s) = par(14);
                    fit_para(m,n,s,:) = par;
                    waitbar(count/roi_len, h);
                    % fitted curves
                    cur = zspec_analysis(par, offs, pn);
                    amide_inv(m,n,s,:) = cur(:,4);
                    rnoe_inv(m,n,s,:) = cur(:,6);
                    mt_inv(m,n,s,:) = cur(:,8);
                    guan_inv(m,n,s,:) = cur(:,10);
                    if mod(count, 200) == 0
                        zspecfit = cur(:,1);
                        water_cur = cur(:,2);
                        amide_cur = cur(:,3);
                        rnoe_cur = cur(:,5);
                        mt_cur = cur(:,7);
                        guan_cur = cur(:,9);
                        figure(100);
                        plot(offs, zspec, 'bo', offs, zspecfit, 'b-',...
                        offs, water_cur, 'r-.', offs, amide_cur, 'g-.',...
                        offs, rnoe_cur, 'c-.', offs, mt_cur, 'm-.',  offs, guan_cur, 'k-.', 'LineWidth',1.5);
    %                     axis([-10,10,0,1.02]); 
                        axis([min(offs(:)),max(offs(:)),0,1.01]); 
                        xlabel('Offset (ppm)'); ylabel('Z');
                        title('Z spectrum'); 
                        legend('Z', 'Z_f_i_t', 'Water', 'Amide', 'rNOE', 'MT', 'Location', 'east');
                        set(gca, 'Xdir', 'reverse', 'FontWeight', 'bold', 'FontSize', 14, 'LineWidth',3)
                        set(gcf,'color','w');
                    end
                end
            end
        end   
    end
    toc
    close gcf;
    delete(h);
    save([filepath, filesep, 'mplf.mat'], 'amide','rnoe','mt','guan','amide_inv','rnoe_inv','mt_inv','guan_inv','db0','offs','img','img_norm','img_m0','roi','fit_para');
else
    load([filepath, filesep, 'mplf.mat']);
end

%% Inverse Z-spectrum analysis maps
offs_intst = [3.5,-3.5,-2.5,2]; % do not change the order: amide, rNOE, MT and guan!
[~,ind] = min(abs(offs-offs_intst));
amide_inv_peak = amide_inv(:,:,:,ind(1));
rnoe_inv_peak = rnoe_inv(:,:,:,ind(2));
mt_inv_peak = mt_inv(:,:,:,ind(3));
guan_inv_peak = guan_inv(:,:,:,ind(4));

%% Save mean values
roi_vec = roi(:);
amide_vec = amide(:);
rnoe_vec = rnoe(:);
mt_vec = mt(:);
guan_vec = guan(:);
amide_mean = mean(amide_vec(roi_vec==1));
rnoe_mean = mean(rnoe_vec(roi_vec==1));
mt_mean = mean(mt_vec(roi_vec==1));
guan_mean = mean(guan_vec(roi_vec==1));
% Inverse Z-spectrum analysis results
amide_inv_vec = amide_inv_peak(:);
rnoe_inv_vec = rnoe_inv_peak(:);
mt_inv_vec = mt_inv_peak(:);
guan_inv_vec = guan_inv_peak(:);
amide_inv_mean = mean(amide_inv_vec(roi_vec==1));
rnoe_inv_mean = mean(rnoe_inv_vec(roi_vec==1));
mt_inv_mean = mean(mt_inv_vec(roi_vec==1));
guan_inv_mean = mean(guan_inv_vec(roi_vec==1));
% Save
all_mean = [amide_mean,rnoe_mean,mt_mean,guan_mean; % CEST
           amide_inv_mean,rnoe_inv_mean,mt_inv_mean,guan_inv_mean]; % CEST inv
save_txt([filepath,filesep,'cestMeanValues_amide_rnoe_mt_guan_mplf.txt'], all_mean);

%% Display
amide_splice = zeros(xn,yn*sn);
rnoe_splice = zeros(xn,yn*sn);
mt_splice = zeros(xn,yn*sn);
guan_splice = zeros(xn,yn*sn);
amide_inv_splice = zeros(xn,yn*sn);
rnoe_inv_splice = zeros(xn,yn*sn);
mt_inv_splice = zeros(xn,yn*sn);
guan_inv_splice = zeros(xn,yn*sn);
for s = 1:sn
    amide_splice(:,(s-1)*yn+1:s*yn) = amide(:,:,s);
    rnoe_splice(:,(s-1)*yn+1:s*yn) = rnoe(:,:,s);
    mt_splice(:,(s-1)*yn+1:s*yn) = mt(:,:,s);
    guan_splice(:,(s-1)*yn+1:s*yn) = guan(:,:,s);
    amide_inv_splice(:,(s-1)*yn+1:s*yn) = amide_inv_peak(:,:,s);
    rnoe_inv_splice(:,(s-1)*yn+1:s*yn) = rnoe_inv_peak(:,:,s);
    mt_inv_splice(:,(s-1)*yn+1:s*yn) = mt_inv_peak(:,:,s);
    guan_inv_splice(:,(s-1)*yn+1:s*yn) = guan_inv_peak(:,:,s);
end
% Plot
set(0,'defaultfigurecolor','w')
% CEST
figure, set(gcf,'unit','normalized','position',[0.3,0.2,0.2,0.6]);
subplot(3,1,1), imagesc(amide_splice),colorbar('fontsize',12,'fontweight','bold'),caxis([0,0.08]),axis off,colormap(jet);title('Amide')
subplot(3,1,2), imagesc(rnoe_splice),colorbar('fontsize',12,'fontweight','bold'),caxis([0,0.06]),axis off,colormap(jet);title('rNOE')
subplot(3,1,3), imagesc(mt_splice),colorbar('fontsize',12,'fontweight','bold'),caxis([0,0.20]),axis off,colormap(jet);title('MT')
% subplot(4,1,4), imagesc(guan_splice),colorbar('fontsize',12,'fontweight','bold'),caxis([0,0.10]),axis off,colormap(inferno);title('Guan')
% CEST inv
figure, set(gcf,'unit','normalized','position',[0.5,0.2,0.2,0.6]);
subplot(3,1,1), imagesc(amide_inv_splice),colorbar('fontsize',12,'fontweight','bold'),caxis([0,0.15]),axis off,colormap(jet);title('Amide inv')
subplot(3,1,2), imagesc(rnoe_inv_splice),colorbar('fontsize',12,'fontweight','bold'),caxis([0,0.1]),axis off,colormap(jet);title('rNOE inv')
subplot(3,1,3), imagesc(mt_inv_splice),colorbar('fontsize',12,'fontweight','bold'),caxis([0,0.35]),axis off,colormap(jet);title('MT inv')
% subplot(4,1,4), imagesc(guan_inv_splice),colorbar('fontsize',12,'fontweight','bold'),caxis([0,0.15]),axis off,colormap(inferno);title('Guaninv')