% we are using prediction measures that do not take advantage of the random
% intercept at least in this case, predicting the whole session

threshE = 0;
propT = 15;  
propFlag = 1;

uniqSess = unique(stack.session);
nS = length(uniqSess);
predCC = zeros(nS,2);
sensit = zeros(nS,2);
MSE = zeros(nS,2);
AUC = zeros(nS,2);

ypredAUC=[];
aucLABELS =[];

for i = 1:nS
    stackA = stack( stack.session ~= nominal(uniqSess(i)), :);
    stackB = stack( stack.session == nominal(uniqSess(i)), :);

    lme1 = fitlme(stackA,[bands{bandI} '~ distance+(1|session)']);
    lme2 = fitlme(stackA,[bands{bandI} '~ distance+FC8+(1|session)']);
    
    ypred = [];
    ypred(:,1) = predict(lme1, stackB);
    ypred(:,2) = predict(lme2, stackB);
    
    predCC(i,1)=corr(ypred(:,1), eval(['stackB.' bands{bandI}]));
    predCC(i,2)=corr(ypred(:,2), eval(['stackB.' bands{bandI}]));
    
    if propFlag
        topT = round(length(ypred(:,1))*propT/100);
    else
        topT = propT;
    end
    [~,trueTop] = maxk(eval(['stackB.' bands{bandI}]), topT);
    
    if threshE
        trueTop = find(eval(['stackB.' bands{bandI}]) > threshE);
        topT = length(trueTop);
    end

    predTop=[];
    [~,predTop(:,1)] = maxk(ypred(:,1), topT);
    [~,predTop(:,2)] = maxk(ypred(:,2), topT);
    

    MSE(i,1)=mean((ypred(:,1)-eval(['stackB.' bands{bandI}])).^2);
    MSE(i,2)=mean((ypred(:,2)-eval(['stackB.' bands{bandI}])).^2);
    
    sensit(i,1) = length(intersect(trueTop, predTop(:,1)))/length(trueTop);
    sensit(i,2) = length(intersect(trueTop, predTop(:,2)))/length(trueTop);
    
    
    
    % AUC stuff
    aucLabels = zeros(size(ypred,1),1);
    aucLabels(trueTop)=1;
    

    [~,~,~,AUC(i,1)] = perfcurve(aucLabels,ypred(:,1), 1);
    [~,~,~,AUC(i,2)] = perfcurve(aucLabels,ypred(:,2), 1);    
    
    
%     plotResiduals(lme2)
%     hist(randomEffects(lme2))
%     saveas(gcf, ['delta' num2str(i) '.png'])
    
   
end



figure(3)
set(gcf, 'Position', [440   579   496   219])

subplot(1,3,1)
hold off
boxplot(predCC)
hold on
plot(predCC', 'k-o')
ylabel(' Corr.')
[signR_p,~,stats] = signrank(predCC(:,1), predCC(:,2), 'method', 'approximate');
title([num2str(stats.zval) ' p=' num2str(signR_p) ])

subplot(1,3,2)
hold off
boxplot(AUC)
hold on
plot(AUC', 'k-o')
ylabel('AUC')
[signR_p,~,stats] = signrank(AUC(:,1), AUC(:,2), 'method', 'approximate');
title([num2str(stats.zval) ' p=' num2str(signR_p) ])


subplot(1,3,3)
hold off
boxplot(sensit)
hold on
plot(sensit', 'k-o')
ylabel('sensit')
[signR_p,~,stats] = signrank(sensit(:,1), sensit(:,2), 'method', 'approximate');
title([num2str(stats.zval) ' p=' num2str(signR_p) ])


% figure(4)
% plot(x1, y1)
% hold on
% plot(x2, y2)
% legend({'without FC_L','with FC_L'})
% ylabel('sensitivity')
% xlabel('1-specificity')


