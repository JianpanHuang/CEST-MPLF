function [mask, num] = drawRoi(img, path, name, cm, cc, thres)
% Author: Jianpan Huang   Email: jianpanhuang@outlook.com
%
% FUNCTION:
%           Draw region of interest (ROI) in piecewise way 
% INPUT:
%           img: reference image                                       
%           path: path for saving ROI                       
%           name: saved ROI name                                       
%           cm: colormap type                                          
%           cc: color of ROI contour                                
%           thre: threshold ratio (0~1) for ROI filtering if necessary    
% OUTPUT:
%           mask: ROI matrix                                           
%           num: ROI number 

%%
if nargin < 3
    name = 'mask';
    cm = 'gray'; 
    cc = 'm';
    thres = 0;
end
if nargin < 4
    cm = 'gray'; 
    cc = 'm';
    thres = 0;
end
if nargin < 5
    cc = 'm';
    thres = 0;
end
if nargin < 6
    thres = 0;
end

sz = size(img);
if length(sz) == 2
    sz(3) = 1;
end
vect = sort(img(:),'descend');
maxVal = mean(vect(1:5));
if ~exist([path,filesep,name,'.mat'],'file') == 1
    mask = zeros(sz(1),sz(2),50,sz(3));
    num = zeros(sz(3));
    for ss = 1:sz(3)
        imgTemp = img(:,:,ss);
        num(ss) = setRoiNum;
        for nr = 1:num(ss)
            scrSz = get(0,'ScreenSize');
            h = figure;
            set(h,'Position',[scrSz(3)*0.3 scrSz(4)*0.3 scrSz(3)*0.4 scrSz(4)*0.6]); 
            imagesc(imgTemp),colormap(cm);
            title(['Please draw the ROI',num2str(nr)])
            temp = roipoly;
            temp(imgTemp < maxVal*thres) = 0;
            mask(:,:,nr,ss) = temp;
            % Display
            close gcf;
            h = figure;
            set(h,'Position',[scrSz(3)*0.01 scrSz(4)*0.3 scrSz(3)*0.4 scrSz(4)*0.6]); 
            imagesc(imgTemp); axis image;colormap(cm);
            hold on
            % temp(isnan(temp))=0;
            roiTemp = mask(:,:,nr,ss);
            contour(roiTemp,1,[cc,'-'],'LineWidth',2);
            title(['ROI profile of slice ',num2str(ss)])
            msg = 'Is the ROI OK?';
            tit = 'Confirm ROI';
            button=questdlg(msg, tit, 'OK and continue', 'No', 'OK and continue');
            if strcmp(button,'No')
                  error('You need to draw ROI again!')
            end
            close gcf; 
        end
    end
    mask(:,:,max(num(:))+1:end,:) = [];
    save([path,filesep,name,'.mat'],'mask','num') 
else
    load([path,filesep,name,'.mat'],'mask','num'); % Load ROI
    % Display
    for ss = 1:size(mask,4)
        imgTemp = img(:,:,ss);
        if ~exist('num','var')  == 1
            num=1;
        end
        for nr = 1:num(ss)
            roiTemp = sum(mask(:,:,nr,ss),3);
            figure
            imagesc(imgTemp); axis image;colormap(cm)
            hold on
            contour(roiTemp,1,[cc,'-'],'LineWidth',2);
            title(['ROI profile of slice ',num2str(ss)])
            pause(1.5);
            close gcf;
        end
    end
end