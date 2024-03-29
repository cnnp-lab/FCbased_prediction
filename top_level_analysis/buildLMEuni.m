
load preproc_output2.mat


if enableLTVs==1
    features = LTVs;
    disp('LTVs loaded')
elseif enableLTVs==2
    features = LTTs;
    disp('LTTs loaded')
elseif enableLTVs~=0
    error('set a valid value for LTT/LTV enabler: 0, 1, or 2')
end

[stack, vLabels] = stackFeatures(effPerSes,features,...
                                 highRespBand, thresh,sesAA,subjAA,...
                                 tSince, timeWind, stimLoc, specLoc);
                              

bands = vLabels(1:5);               % frequency bands
featureLab = vLabels(6:end-2);      % feature labels


% number of sessions
nS = length(unique(stack.session));
disp('Number of sessions available for these settings:')
disp(nS)

for i = 1:length(bands)
    for j = 1:length(featureLab)
        
        eq = [bands{i} '~' featureLab{j} '+(1|session)'];
        lme = fitlme(stack,eq);

        R2(i,j)= lme.Rsquared.ordinary;
        
        Estim(i,j) = single(lme.Coefficients(end,2));
        SEs(i,j) = single(lme.Coefficients(end,3));
        Tstat(i,j) = single(lme.Coefficients(end,4));
        pVals(i,j) = single(lme.Coefficients(end,6));
    
    end
end
clear eq

% calc z-value based on Estim and SE, following Mohan2020
Zs = Estim ./ SEs;

if enableLTVs
    Zs = Zs(:, end:-1:1);
end

% visualise the results only for the chosen freq. band, bandI
figure
bar(0:length(Zs(bandI,:))-1, Zs(bandI,:))
box off
set(gcf, 'Position', [360   568   424   130])
ylabel('param. estim. / SE')
ylim([0 10])
set(gcf,'color','white')
if ~enableLTVs
    load altLabels
    set(gca,'XTickLabel', altLabels_short)
end
