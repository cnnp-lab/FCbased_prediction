% use randomly chosen channels to predict the rest

plotNpause = 0;

prop = 0.50;    % proportion of channels to be used for training

% propT =15;  
% propFlag=0;

uniqSess = unique(stack.session);
nSes = length(uniqSess);

CC  = zeros(nSes,2);

ZVALS = [];
PVALS = [];
tic
for repeatI = 1:20    % used 5000 for the reported results
    savedTrue = []; savedPred1=[]; savedPred2=[]; %for temp saving example
    CCdiffmax = 0;
    
    for i = 1:nSes
        restSes = stack( stack.session ~= nominal(uniqSess(i)), :);
        currSes = stack( stack.session == nominal(uniqSess(i)), :);

        for j = 1:length(prop)  

            rp = randperm(height(currSes));

            K = round(height(currSes)*prop(j));

            trainK = rp(1: K);
            testK = rp(K+1 : end);


            currSesTrain = currSes(trainK, :);
            currSesTest = currSes(testK, :);

            combo = [restSes; currSesTrain];


            lme1 = fitlme(combo,[bands{bandI} '~ distance+(1|session)']);
            lme2 = fitlme(combo,[bands{bandI} '~ distance+FC8+(1|session)']);

            ypred1 = predict(lme1, currSesTest);
            ypred2 = predict(lme2, currSesTest);

            % if propFlag
            %     topT = round(length(ypred1)* propT/100);
            % else
            %     topT = propT;
            % end
            % 
            % [~,trueTop] = maxk(eval(['currSesLeave.' bands{bandI}]), topT);
            % [~,predTop1] = maxk(ypred1, topT);
            % [~,predTop2] = maxk(ypred2, topT);

            CC(i,1)=corr(ypred1, eval(['currSesTest.' bands{bandI}]));
            CC(i,2)=corr(ypred2, eval(['currSesTest.' bands{bandI}]));
            
            % save the true y and the ypred1 and ypred2 of the best example
            % session in the current repeat
            CCdiff = CC(i,2) - CC(i,1);
            if CCdiff > 0.5 && CCdiff > CCdiffmax
                CCdiffmax = CCdiff;
                savedTrue = eval(['currSesTest.' bands{bandI}]);
                savedPred1 = ypred1;
                savedPred2 = ypred2;
            end
        end
    end

    [signR_p,~,stats] = signrank(CC(:,2), CC(:,1));
    ZVALS = [ZVALS stats.zval];
    PVALS = [PVALS signR_p];
    
    % % visualise representative iteration
    % if stats.zval > 1.78 && stats.zval < 1.87 && CCdiffmax>0.5
    %     hold off
    %     boxplot(CC)
    %     hold on
    %     plot(CC', 'k-o')
    %     ylabel(' Corr.')
    %     title([num2str(stats.zval) ' p=' num2str(signR_p) ])
    %     set(gcf, 'Position', [440   524   173   274])
    %     beep
    % end
    
    if mod(repeatI, 20)==0
        disp(repeatI)
    end
    
end

histogram(ZVALS,20)
box off
set(gcf, 'Position', [440   646   254   152])

disp('median of zvals:')
disp(median(ZVALS))

disp('median of pvals:')
disp(median(PVALS))
toc
