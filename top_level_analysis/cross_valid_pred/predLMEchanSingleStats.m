
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
for j = 1:length(featL)
    for i = 1:nS
        substack = stack.session==uniqSess(i);
        
        [signR_p, ~, signR_stats] = signrank(SE(substack,1), SE(substack,j+1));
        pvals(i,j) = signR_p;
        zvals(i,j) = signR_stats.zval;
        

    end
    
end




% visualise results with two heatmaps/image plots
figure
maxz = max([zvalsMix zvals(:)'] );
[~, sortI1] = sort(zvalsMix, 'descend');
subplot(6, 1, 1)
colormap(flipud(gray))
imagesc(zvalsMix(sortI1), [0 maxz]);
set(gca, 'YTick', [])
set(gca, 'XTick', [])
colorbar

subplot(6, 1, 2:6)
colormap(flipud(gray))
imagesc( zvals(:,sortI1), [0 maxz]);
ylabel('session')

load altLabels.mat
altLabels_short(1)=[];

set(gca, 'YTick', [])
set(gca, 'XTickLabels', altLabels_short(sortI1))
ch = colorbar;
ch.Label.String = 'improvement on squared error';
set(gcf, 'Position', [700   458   919   234])
