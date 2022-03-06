% leave one channel out cross-validation
% calculation of squared error (SE)

uniqSess = unique(stack.session);
nS = length(uniqSess);

featL ={'FC2', 'FC3', 'FC4', 'FC5', 'FC6', 'FC7', 'FC8', 'SC1', 'SC2'};

SE= -ones(height(stack), 1+length(featL));
trueResp = -99* ones(height(stack), 1);
predResp = -99* ones(height(stack), 1+length(featL));


dText = sprintf('Cross-validation progress - channels processed (out of %d):',...
                    height(stack));

for i = 1:height(stack)
    
    
    boolI = false(height(stack), 1);
    boolI(i) = true;
    rest = stack( ~boolI, :);
    target = stack( boolI, :);
    
    lme1 = fitlme(rest,[bands{bandI} '~ distance+(1|session)']);
    ypred1 = predict(lme1, target);
    trueResp(i,1) = eval(['target.' bands{bandI}]);
    
    SE(i,1)=(ypred1-trueResp(i,1)).^2;
    predResp(i,1) = ypred1;
    
      
    for j = 1:length(featL)
        lme2 = fitlme(rest,[bands{bandI} '~ distance+' featL{j} '+(1|session)']);
        ypred2 = predict(lme2, target);
        SE(i,j+1)=(ypred2-trueResp(i,1)).^2;
        predResp(i,j+1) = ypred2;         
    end
    
    
    if mod(i,50)==0
        clc
        disp(dText)
        disp(i)
    end

    
end
disp('All processed')



