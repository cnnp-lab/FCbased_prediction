% we are using prediction measures that do not take advantage of the random
% intercept at least in this case, predicting the whole session


uniqSess = unique(stack.session);
nS = length(uniqSess);
predCC = zeros(nS,2);


for i = 1:nS
    stackA = stack( stack.session ~= nominal(uniqSess(i)), :);
    stackB = stack( stack.session == nominal(uniqSess(i)), :);

    % two models: lme1 has no FCL , lme2 has FCL
    lme1 = fitlme(stackA,[bands{bandI} '~ distance+(1|session)']);
    lme2 = fitlme(stackA,[bands{bandI} '~ distance+FC8+(1|session)']);
    
    ypred = [];
    ypred(:,1) = predict(lme1, stackB);
    ypred(:,2) = predict(lme2, stackB);
    
    predCC(i,1)=corr(ypred(:,1), eval(['stackB.' bands{bandI}]));
    predCC(i,2)=corr(ypred(:,2), eval(['stackB.' bands{bandI}]));

end


hold off
boxplot(predCC)
hold on
plot(predCC', 'k-o')
ylabel(' Correlation')
[signR_p,~,stats] = signrank(predCC(:,1), predCC(:,2), 'method', 'approximate');
title([num2str(stats.zval) ' p=' num2str(signR_p) ])
set(gca, 'XTickLabels', {'without FCL', 'with FCL'})
