function roi = draw_load_roi(path, img, name, shape, bcg_thres)
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
    pause(2);
    close gcf;
end
end