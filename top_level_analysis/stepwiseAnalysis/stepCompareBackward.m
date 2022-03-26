
% labels to be used in the equations
fLabels ={'distance','FC2', 'FC3', 'FC4', 'FC5', 'FC6', 'FC7', 'FC8', 'SC1', 'SC2'};
%            D        FCA    FCC    FCM    FCsA   FCsC   FCsM   FCL    SCslc  SCgfa

maxLRstat = 1000;

countSubPl = 1;

% established starts full and it diminished through the loop
established = 1: length(fLabels);

tobeRemoved =[];

while length(established)>2
    
    established = setdiff(established, tobeRemoved);

    % fit with established model
    eq = formEq(fLabels, bands{bandI}, established , randInter);
    Lme_ext = fitlme(stack, eq);
    
    disp(eq)
    
    LRstat = zeros(1,length(established));

    for i = 1: length(established)
        
        establishedMinus = setdiff(established, established(i));
        
        %fit with extended model, must be nested in the established one
        eq = formEq(fLabels, bands{bandI}, establishedMinus , randInter);
        Lme = fitlme(stack, eq);

        compRes = compare(Lme, Lme_ext, 'CheckNesting', true);
        LRstat(i) = single(compRes(end,6));
    end


    % find the max Likelihood ratio statistic across the added features
    [minLRstat, minI] = min(LRstat);
    tobeRemoved = established(minI);

end

% final set
established = setdiff(established, tobeRemoved);
eq = formEq(fLabels, bands{bandI}, established , randInter);
disp(eq)