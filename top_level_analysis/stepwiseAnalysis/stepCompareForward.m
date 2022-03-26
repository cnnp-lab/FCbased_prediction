

bandL = bands{bandI};

load altLabels
featlabels ={'distance','FC2', 'FC3', 'FC4', 'FC5', 'FC6', 'FC7', 'FC8', 'SC1', 'SC2'};
%               D        FCA    FCC    FCM    FCsA   FCsC   FCsM   FCL    SCslc  SCgfa

if enableLTVs==1
    featlabels ={'H99','H5', 'H4', 'H3', 'H2', 'H1', 'H0'};
elseif enableLTVs==2
    featlabels ={'H99','H5', 'H4', 'H3', 'H2', 'H1', 'H0'};
end

LRstat = zeros(1,length(featlabels));

numSubPl = 5;
LRthresh = 6;
maxLRstat = 1000;
newPred = '';
countSubPl = 1;
h = [];     % subplot handles

% initial established model 
established = '1+(1|session)';
% established = '1';


while maxLRstat > LRthresh
    
    established = [newPred established ];

    % fit with established model
    Lme = fitlme(stack, [ bandL '~' established]);

    for i = 1:length(featlabels)
        X = featlabels{i};
        
        %fit with extended model, must be nested in the established one
        Lme_ext = fitlme(stack, [ bandL '~' X '+' established ]);

        compRes = compare(Lme, Lme_ext, 'CheckNesting', true);
        LRstat(i) = single(compRes(end,6));
    end
    
    % for visualizing veru small values on log axis
    % 0.002 as the min value to be visualized
    LRstat(LRstat<0.002 & LRstat>0) = 0.002;

    h(end+1) = subplot(numSubPl, 1, countSubPl);
    bar(LRstat)
    hold on
    plot([0 length(featlabels)+1], [LRthresh LRthresh], 'r')
    box off
    if numSubPl == countSubPl
        set(gca,'XTickLabel', altLabels_short)
    else
        set(gca,'XTickLabel', [])
    end
    
    % find the max Likelihood ratio statistic across the added features
    [maxLRstat, maxI] = max(LRstat);
    
    newPred =  [ featlabels{maxI} '+'];
    
    
    countSubPl = countSubPl+1;
end
set(gcf, 'Position', [360   286   402   412])
set(gcf,'color','white')

disp('final model:')
disp([ bandL '~ 1+'  established])