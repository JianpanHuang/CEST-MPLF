%% Pixelwise Lorentzian fitting for generating CEST maps 
if ~exist([dataPath, filesep, 'CESTmaps_4pools.mat'],'file') == 1
    amideMap = zeros(xn, yn);
    noeMap = zeros(xn, yn);
    mtMap = zeros(xn, yn);
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
                % Fitted arameters
                par = lsqcurvefit(@lorentzian4pool,iv,offs,zTemp,lb,ub);
                amideMap(m,n) = par(5);
                noeMap(m,n) = par(8);
                mtMap(m,n) = par(11);
                waitbar(count/maskLen, h);
                count = count+1;
                % Fitted curves
                res = zSpecLorentzDecomp(par, offs, pn);
                zTempFit = res(:,1);
                waterTemp = res(:,2);
                amideTemp = res(:,3);
                noeTemp = res(:,4);
                mtTemp = res(:,5);
                if mod(count, 100) == 0
                    plot(offs, zTemp, 'bo', offs, zTempFit, 'b-',...
                    offs, waterTemp, 'r-.', offs, amideTemp, 'g-.',...
                    offs, noeTemp, 'c-.', offs, mtTemp, 'm-.', 'LineWidth',1.5);
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
    save([dataPath, filesep, 'CESTmaps_4pools.mat'], 'amideMap', 'noeMap', 'mtMap')
else
    load([dataPath, filesep, 'CESTmaps_4pools.mat']);
end

%% Plot CEST maps
figure, set(gcf,'unit','normalized','position',[0.1,0.7,0.8,0.3]);
subplot(1,3,1), imagesc(amideMap),colormap(parula),colorbar,caxis([0,0.1]),axis off,title('Amide')
subplot(1,3,2), imagesc(noeMap),colormap(parula),colorbar,caxis([0,0.1]),axis off,title('NOE')
subplot(1,3,3), imagesc(mtMap),colormap(parula),colorbar,caxis([0,0.15]),axis off,title('MT')