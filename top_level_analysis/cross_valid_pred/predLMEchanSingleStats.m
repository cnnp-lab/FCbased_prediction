
% stats and visualization of results, the stack for the corresponding band should be
% first produced (using buildLMEuni) and then load file e.g. SEtheta25.mat

% caution: the first column of SE matrix (and predResp) refers to squared error by using
% the simpler model which includes only D, the rest of the columns refer to
% the models that include one more feature


% all sessions together
pvalsMix = [];
zvalsMix = [];
for j = 1:length(featL)
    % j+1 refers to the model with the jth feature added to the model
    % including only D, whereas 1 refers to the model with D only
    [signR_p, ~, signR_stats] = signrank(SE(:,1), SE(:,j+1));

    pvalsMix(j) = signR_p;
    zvalsMix(j) = signR_stats.zval;
end



% each session separately
pvals = [];
zvals = [];
pvals_Z = [];
zvals_Z = [];
for j = 1:length(featL)
    for i = 1:nS
        substack = stack.session==uniqSess(i);
        
        [signR_p, ~, signR_stats] = signrank(SE(substack,1), SE(substack,j+1));
        pvals(i,j) = signR_p;
        zvals(i,j) = signR_stats.zval;
        
        
        % demonstration that zscoring the true values , predicted
        % values per session and then computing SE again and then
        % running the same signrank test, different results
        TR = trueResp(substack);
        TRz= (TR-mean(TR))/std(TR);
        PR1 = predResp(substack,1);
        PR1z= (PR1-mean(PR1))/std(PR1);
        PR2 = predResp(substack,j+1);
        PR2z= (PR2-mean(PR2))/std(PR2);
        SE1z = (TRz - PR1z).^2;
        SE2z = (TRz - PR2z).^2;
        
        
        % % temporary visualization of z-score results
        % if j==1
        %     h(1)=subplot(1,2,1);
        %     hold off
        %     scatter(PR1,TR,25,SE(substack,1),'filled');
        %     hold on
        %     plot([0 2], [0 2], 'k')
        %     title('original')
        %     ylabel('true value')
        %     xlabel('prediction')
        % 
        %     h(2)= subplot(1,2,2);
        %     hold off
        %     scatter(PR1z,TRz,25,SE1z,'filled');
        %     hold on
        %     plot([-1 3], [-1 3], 'k')  
        %     title('z-scored')
        %     ylabel('true value')
        %     xlabel('prediction')
        % 
        %     %linkaxes(h)
        %     pause
        % end
        
        
        
        [signR_p_Z, ~, signR_stats_Z] = signrank(SE1z, SE2z);  
        pvals_Z(i,j) = signR_p_Z;
        zvals_Z(i,j) = signR_stats_Z.zval;
        
        if j == 7 && i==15 && nS==25
            % j==7 corresponds to FC8/FCL
            % example visualization either i==16 or 15
            % nS==25 corresponds to theta reported results
            % hist(SE(substack,1) - SE(substack,j+1), 20)
            
            % boxplot(SE(substack,[1 j+1]))
            % hold on
            % plot(transpose(SE(substack,[1 j+1])), 'k-o')        
            
            % % scatter the z-scored values
            % h(1) = subplot(1,2,1);
            % scatter( PR1z, TRz)
            % hold on
            % plot([-2 5], [-2 5], 'k:')
            % axis([-2 5 -2 5])
            % axis equal
            % axis square
            % xlabel('pred'); ylabel('true')
            % h(2) = subplot(1,2,2);
            % scatter( PR2z,TRz)
            % hold on
            % plot([-2 5], [-2 5], 'k:')
            % axis([-2 5 -2 5])
            % axis equal
            % axis square          
            % xlabel('pred'); ylabel('true')
            % title(num2str(i))
            % linkaxes(h)
            
            % scatter original values
            h(1) = subplot(1,2,1);
            scatter( PR1, TR)
            hold on
            plot([-2 5], [-2 5], 'k:')
            xlim([0.4 1.7])
            axis square
            xlabel('pred'); ylabel('true')
            h(2) = subplot(1,2,2);
            scatter( PR2,TR)
            hold on
            plot([-2 5], [-2 5], 'k:')
            xlim([0.4 1.7])
            axis square
            xlabel('pred'); ylabel('true')
            title(num2str(i))
            linkaxes(h)
            
            % session-wise MSE for the simple model and the jth feature
            % this is only for supplementary - sanity check
            MSEtemp(1) = mean(SE(substack,1));
            MSEtemp(2) = mean(SE(substack,j+1));
            disp(MSEtemp)

        end
        

    end
    
end





figure
maxz = max([zvalsMix zvals(:)'] );
[~, sortI1] = sort(zvalsMix, 'descend');
subplot(6, 1, 1)
colormap(flipud(gray))
imagesc(zvalsMix(sortI1), [0 maxz]);
% colormap(unionjack)
% imagesc(zvalsMix(sortI), [-maxz maxz]);
set(gca, 'YTick', [])
set(gca, 'XTick', [])
colorbar

subplot(6, 1, 2:6)
colormap(flipud(gray))
imagesc( zvals(:,sortI1), [0 maxz]);

set(gca, 'YTick', [])
set(gca, 'XTickLabels', featL(sortI1))
colorbar
set(gcf, 'Position', [700   458   919   234])




figure
midZval = median(zvals_Z);
[~, sortI2] = sort(midZval, 'descend');
subplot(6, 1, 1)
colormap(flipud(gray))
imagesc(midZval(sortI2), [0 max(midZval)]);

set(gca, 'YTick', [])
set(gca, 'XTick', [])
colorbar

subplot(6, 1, 2:6)
colormap(flipud(gray))
imagesc(zvals_Z(:,sortI2), [0 max(zvals_Z(:))]);

set(gca, 'YTick', [])
set(gca, 'XTickLabels', featL(sortI2))
colorbar
set(gcf, 'Position', [805   458   919   234])



if ~all(sortI1 == sortI2)
    warning('sorting is different')
end


% figure
% boxplot(MSE)
% hold on
% plot(MSE', 'k-o')
% ylabel('MSE')
% [signR_p,~,stats] = signrank(MSE(:,1), MSE(:,2));
% title([num2str(stats.zval) ' p=' num2str(signR_p) ])