function [stack, varLabels] = stackFeatures(effPerSes,features, absFlag,...
                                transFlag, band, thresh, sesAA, subjAA,...
                                tSince, timeWind, stimLoc, specLoc)
%STACKFEATURES stacks effects and features and produces a nominal variable
%with session number alongside the others

load varLabels.mat

if size(features{1}, 2) == 7
    varLabels = varLabelsLTV;
end

if size(features{1}, 2) == 10
    varLabels = varLabelsDefault;
end

if size(features{1}, 2) == 9
    varLabels = varLabelsLTT;
end


numFeatures = size(features{1}, 2);
numBands = size(effPerSes{1}, 2);

stack = zeros(0, numFeatures + numBands + 2);

% array placeholders for the number and the proportion of channels above
% the threshold
numAbove = [];
propAbove = [];


for i = 1: length(effPerSes)
    nChAboveThr = [];
    nCh = length(effPerSes{i});
    
    % apply the absolute on both features and effect, if chosen
    if absFlag
        x =abs(effPerSes{i});
        y =abs(features{i});
    else
        x =effPerSes{i};
        y =features{i};
    end
    
    
    % % remove zeros before standardization
    % disp('removing zeros from SC before standardization')
    % y(y==0) = NaN;
    
    
    
    % standardise the explanatory variables only those with std~=0
    % https://ourcodingclub.github.io/tutorials/mixed-models/
    for j = 1:size(y,2)
        if std(y(:,j),'omitnan' ) ~=0
            y(:,j) = y(:,j) - mean(y(:,j),'omitnan' );
            y(:,j) = y(:,j)./std(y(:,j),'omitnan' );
        end
    end
    

    
    % skip the session if it doesn't have strong enough response in a
    % specific band (95th percentile)
    if ~isempty(thresh)
        if isempty(band)
            if prctile(x(:),95) < thresh
                continue
            end
            nChAboveThr = sum(x(:) >= thresh);
        else
            if all(prctile(x(:,band),95) < thresh)
                continue
            end
            nChAboveThr = sum(x(:,band) >= thresh);
        end
    end

    
    % % skip the session if it doesn't have strong enough response in a
    % % specific band (top 5 channels)
    % if ~isempty(thresh)
    %     if any(maxk(x(:,band), 5) < thresh)
    %         continue
    %     end
    % end
    
    
    
    % skip the session if it is not in the specified time window after the
    % very first stim session
    if tSince(i) > timeWind
        continue
    end
    
    % skip the session if it is not in the specified stim loc, if specified
    if ~isempty(specLoc) && stimLoc(i) ~= specLoc
        continue
    end    
    
    % apply transformation on the effect values, if any
    if transFlag==1
        appendix = [x.^3 y sesAA(i)*ones(nCh,1) subjAA(i)*ones(nCh,1)];
    elseif transFlag==2
        appendix = [x-x./(0.1*x.^8 +1) y sesAA(i)*ones(nCh,1) subjAA(i)*ones(nCh,1)];
    else
        appendix = [x y sesAA(i)*ones(nCh,1) subjAA(i)*ones(nCh,1)];
    end
    
    % attach the currect session to the stack
    stack = [stack; appendix];
    
    
    % save the number of channels above the threshold 
    numAbove = [numAbove; nChAboveThr];
    
    % save the proportion of channels above the threshold
    propAbove = [propAbove; nChAboveThr/ nCh];
    
    
end

% information on the choice of transformation
if transFlag==1
    disp('cubic transformation applied')
elseif transFlag==2
    disp('reasonable transformation applied')
else
    disp('no transformation applied')
end


stack = array2table(stack, 'VariableNames' , varLabels);
stack.session = nominal(stack.session);
stack.subject = nominal(stack.subject);

disp('25th 50th and 75th percentile of the proportions above the thresh:')
disp(prctile(propAbove, [25 50 75]))

end

