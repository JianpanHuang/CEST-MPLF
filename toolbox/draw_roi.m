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
        % e = drawpolygon(gca);
        roi = roipoly;
        % e = impoly(gca);
        % roi = createMask(e); 
    elseif strcmp(shape,'rectangle')
        % e = drawrectangle(gca);
        e = imrect(gca);
        roi = createMask(e); 
    elseif strcmp(shape,'ellipse')
        % e = drawellipse(gca);
        e = imellipse(gca);
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
    % e = drawfreehand(gca);
    e = imfreehand(gca);
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