%% Pixelwise Lorentzian fitting for generating CEST maps 
if ~exist([dataPath, filesep, 'CESTmaps_5pools.mat'],'file') == 1
    amideMap = zeros(xn, yn);
    noeMap = zeros(xn, yn);
    mtMap = zeros(xn, yn);
    amineMap = zeros(xn, yn);
    maskVec = mask(:);
    maskVec(maskVec==0) = [];
    maskLen = length(maskVec);
    count = 1;
    h = waitbar(0, 'Doing Lorentzian fitting pixel by pixel, please wait >>>>>>'); 
    set(h, 'Units', 'normalized', 'Position', [0.38, 0.2, 0.24, 0.08])
    figure;
    for m = 1:xn
        for n = 1:yn
            if mask(m,n) == 1
                zTemp = squeeze(zImgNorm(m,n,:));
                % Fitted parameters
                par = lsqcurvefit(@lorentzian5pool,iv,offs,zTemp,lb,ub);
                amideMap(m,n) = par(5);
                noeMap(m,n) = par(8);
                mtMap(m,n) = par(11);
                amineMap(m,n) = par(14);
                waitbar(count/maskLen, h);
                count = count+1;
                % Fitted curves
                res = zSpecLorentzDecomp(par, offs, pn);
                zTempFit = res(:,1);
                waterTemp = res(:,2);
                amideTemp = res(:,3);
                noeTemp = res(:,4);
                mtTemp = res(:,5);
                amineTemp = res(:,6);
                if mod(count, 100) == 0
                    plot(offs, zTemp, 'bo', offs, zTempFit, 'b-',...
                    offs, waterTemp, 'r-.', offs, amideTemp, 'g-.',...
                    offs, noeTemp, 'c-.', offs, mtTemp, 'm-.', offs, amine, 'k-.', 'LineWidth',1.5);
%                     axis([-10,10,0,1.02]); 
                    axis([min(offs(:)),max(offs(:)),0,1.01]); 
                    xlabel('Offset (ppm)'); ylabel('Z (%)');
                    title('Z spectrum'); 
                    legend('Z', 'Z_f_i_t', 'Water', 'Amide', 'NOE', 'MT', 'Location', 'southeast');
                    set(gca, 'Xdir', 'reverse', 'FontWeight', 'bold', 'FontSize', 14)
                end
            end
        end
    end
    close gcf;
    delete(h);
    save([dataPath, filesep, 'CESTmaps_5pools.mat'], 'amideMap', 'noeMap', 'mtMap', 'amineMap')
else
    load([dataPath, filesep, 'CESTmaps_5pools.mat']);
end

%% Plot CEST maps
figure, set(gcf,'unit','normalized','position',[0.25,0.5,0.5,0.5]);
subplot(2,2,1), imagesc(amideMap),colormap(parula),colorbar,caxis([0,0.1]),axis off,title('Amide')
subplot(2,2,2), imagesc(noeMap),colormap(parula),colorbar,caxis([0,0.1]),axis off,title('NOE')
subplot(2,2,3), imagesc(mtMap),colormap(parula),colorbar,caxis([0,0.15]),axis off,title('MT')
subplot(2,2,4), imagesc(amineMap),colormap(parula),colorbar,caxis([0,0.08]),axis off,title('Amine')