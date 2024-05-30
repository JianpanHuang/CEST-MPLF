function roi = draw_load_roi_confirm(path, img, name, shape, bcg_thres)
% FUNCTION:
%   To draw or load ROI for region of interest (ROI)
% INPUT:
%   path: path of image and ROI
%	image: image to draw ROI on
%   name: ROI name
%   shape: ROI shape, can be 'polygon', 'rectangle', 'ellipse', 'circle', 'free', 'auto'
%   bcg_thres: Threshold (normally 0~1) set for backgroud removal, should be given when shape == 'auto' (optional)
% OUTPUT:
%   roi: ROI matrix in logical
% AUTHOR
%   Jianpan Huang, Email: jianpanhuang@outlook.com

%%
if nargin<3
    name = 'roi';
end
if nargin<4
    shape = 'polygon';
end
if nargin<5
	bcg_thres = 0.8;
end

%
if ~exist([path, filesep, name, '.mat'],'file') == 1
    if strcmp(shape,'polygon')||strcmp(shape,'rectangle')||strcmp(shape,'ellipse')||strcmp(shape,'circle')
        roi_num = set_roi_num;
        [xn, yn] = size(img);
        roi = zeros(xn, yn, roi_num);
        for n = 1:roi_num
            roi(:,:,n) = draw_roi(img, shape, bcg_thres);
        end
        scr_sz = get(0,'ScreenSize');
        confirm_roi(img,sum(roi,3),scr_sz);
    elseif strcmp(shape,'free')||strcmp(shape,'auto')
        roi = draw_roi(img, shape, bcg_thres);
        scr_sz = get(0,'ScreenSize');
        confirm_roi(img,sum(roi,3),scr_sz);
    end
    save([path, filesep, name, '.mat'], 'roi');
else
    load([path, filesep, name, '.mat'], 'roi');
    % Confirm ROI
    scr_sz = get(0,'ScreenSize');
    h = figure;
    set(h,'Position',[scr_sz(3)*0.3, scr_sz(4)*0.3, scr_sz(3)*0.4, scr_sz(4)*0.6]); 
    temp = sum(roi,3);
    imagesc(img); axis image; colormap(gray); hold on;
    contour(temp,1,'m-','LineWidth',2);
    title('ROI')
%     pause(2);
%     close gcf;
end

end

function roi = draw_roi(img, shape, factor)
% FUNCTION:
%   To draw ROI for region of interest (roi)
% INPUT:
%	image: image to draw ROI on
%   shape: ROI shape, should be 'polygon', 'rectangle', 'ellipse', 'circle', 'free', 'auto'
%   factor: factor set for backgroud removal, should be given when shape == 'free' or 'auto' (optional)
% OUTPUT:
%   roi: ROI matrix in logical
% AUTHOR
%   Jianpan Huang, Email: jianpanhuang@outlook.com

%%
if nargin<2 
    shape='polygon';
end
if nargin<3
	factor = 0.8;
end

% Draw ROI
scr_sz = get(0,'ScreenSize');
if strcmp(shape,'polygon')||strcmp(shape,'rectangle')||strcmp(shape,'ellipse')||strcmp(shape,'circle')
    h = figure; 
    set(h,'Position',[scr_sz(3)*0.3, scr_sz(4)*0.3, scr_sz(3)*0.4, scr_sz(4)*0.6]); 
    imagesc(img); axis image; colormap('gray');
    title(['1. Draw ROI', newline ,'2. Click continue']);
    if strcmp(shape,'polygon')
        e = drawpolygon(gca);
        roi = createMask(e); 
    elseif strcmp(shape,'rectangle')
        e = drawrectangle(gca);
        roi = createMask(e); 
    elseif strcmp(shape,'ellipse')
        e = drawellipse(gca);
        roi = createMask(e); 
    elseif strcmp(shape,'circle')
        e = drawcircle(gca);
        roi = createMask(e); 
    end
    uicontrol('Position',[372 5 200 40],'String','Continue','Callback','uiresume(gcbf)');
    uiwait(gcf);
    close gcf
elseif strcmp(shape,'free')
    h = figure; 
    set(h,'Position',[scr_sz(3)*0.3, scr_sz(4)*0.3, scr_sz(3)*0.4, scr_sz(4)*0.6]); 
    imagesc(img); axis image; colormap('gray');
    title(['1. Click and hold to draw ROI', newline ,'2. Click continue']);
    e = drawfreehand(gca);
    roi = createMask(e); 
    uicontrol('Position',[372 5 200 40],'String','Continue','Callback','uiresume(gcbf)');
    uiwait(gcf);
    close gcf
    img_std = std2(img(roi==1));
    roi(img<factor*img_std) = 0;
elseif strcmp(shape,'auto')
    img_std = std2(img);
    sz = size(img);
    roi = zeros(sz);
    roi(img>factor*img_std) = 1;
    return;
else 
    errordlg('Mask shape should be polygon, rectangle, ellipse, circle, free or auto', 'Mask error');
    error('Mask shape should be polygon, rectangle, ellipse, circle, free or auto');
end
end

function confirm_roi(img,roi,scr_sz)
% Confirm roi
h = figure;
set(h,'Position',[scr_sz(3)*0.3, scr_sz(4)*0.3, scr_sz(3)*0.4, scr_sz(4)*0.6]); 
imagesc(img); axis image; colormap('gray')
hold on
roi(isnan(roi))=0;
contour(roi,1,'m-','LineWidth',2);
title('ROI');
msg = 'Is the ROI OK?';
tit = 'Confirm ROI';
button = questdlg(msg, tit, 'OK and continue', 'No', 'OK and continue');
if strcmp(button,'No')
    errordlg('Please draw ROI again!','Mask error');
    error('Please draw ROI again!')
end
close gcf; 
end