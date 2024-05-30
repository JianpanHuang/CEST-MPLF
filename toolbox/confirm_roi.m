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