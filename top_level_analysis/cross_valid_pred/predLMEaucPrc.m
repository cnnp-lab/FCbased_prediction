% we are using prediction measures that do not take advantage of the random
% intercept at least in this case, predicting the whole session

% TP1 will refer to true positive of highly responding class
% TP0 will refer to true positive of not responding class
% FP1 and FP0 also used

perc = 0.05 : 0.05 : 0.30;


uniqSess = unique(stack.session);
nS = length(uniqSess);


zvalsAUC = 99*ones(length(perc), 1);

% for collecting ROC curves
ROCX1s={};
ROCX2s={};
ROCY1s={};
ROCY2s={};
      
AUC = zeros(nS, 2, length(perc) );

for i = 1:nS
    stackA = stack( stack.session ~= nominal(uniqSess(i)), :);
    stackB = stack( stack.session == nominal(uniqSess(i)), :);

    lme1 = fitlme(stackA,[bands{bandI} '~ distance+(1|session)']);
    lme2 = fitlme(stackA,[bands{bandI} '~ distance+FC8+(1|session)']);
    
    ypred = [];
    ypred(:,1) = predict(lme1, stackB);
    ypred(:,2) = predict(lme2, stackB);
    
    for k = 1: length(perc)
        
        trueLabels = zeros(size(ypred,1),1);
        predLabels1 = zeros(size(ypred,1),1); 
        predLabels2 = zeros(size(ypred,1),1); 

        [~,trueTop] = maxk(eval(['stackB.' bands{bandI}]), round(perc(k)*length(trueLabels)));
        trueLabels(trueTop)=1;
        
        [~,predTop1] = maxk(ypred(:,1), round(perc(k)*length(trueLabels)));
        [~,predTop2] = maxk(ypred(:,2), round(perc(k)*length(trueLabels)));
        
        predLabels1(predTop1)=1;
        predLabels2(predTop2)=1;
        
        CM1 = confusionmat(trueLabels, predLabels1, 'order',[1 0]);
        CM2 = confusionmat(trueLabels, predLabels2, 'order',[1 0]);
        
        
        [ROCX1,ROCY1,~,AUC(i,1,k)] = perfcurve(trueLabels,ypred(:,1), 1);
        [ROCX2,ROCY2,~,AUC(i,2,k)] = perfcurve(trueLabels,ypred(:,2), 1);
      
        
        % collect all the ROC curves for the chosen percentage value
        if perc(k)==chosenPerc
            ROCX1s{end+1} = ROCX1;
            ROCX2s{end+1} = ROCX2;
            ROCY1s{end+1} = ROCY1;
            ROCY2s{end+1} = ROCY2;            
        end
        clear ROCX1 ROCX2 ROCY1 ROCY2
    end
end

%%
for k = 1:length(perc)

        [~,~,stats] = signrank(AUC(:,2,k), AUC(:,1,k), 'method', 'approximate');
        zvalsAUC(k) = stats.zval;
        
end

% --------------
ROCstruc.ROCX1s = ROCX1s;
ROCstruc.ROCX2s = ROCX2s;
ROCstruc.ROCY1s = ROCY1s;
ROCstruc.ROCY2s = ROCY2s;
ROCstruc.perc = chosenPerc;
averROC(ROCstruc)
%-------------


figure
bar(perc, zvalsAUC)
ylim([-0.5 2])
xlim([0 0.35])
ylabel('AUC')
box off



