function [effPerSes, sesAA, subjAA] = extrEffPerSes(eff8Map,SesV,chanListRef, subjV, tSince)
% extract the effect for the valid channels, all bands
% first output numSessions x 1 cell 
% each cell containing nChannelsx nBands


effPerSes={};
sesAA = [];
subjAA = [];
nSubj = length(SesV);
k=1;

for i =1:nSubj

    sesV = SesV{i};
    

    % get the effect vector for each session of the curr subject
    for j = 1:length(sesV)
        
        % works for this dataset but not ideal in general
        if j>1 && tSince(k)==0
            break
        end
        
        ref =chanListRef{k};

        
        effV = squeeze(eff8Map(sesV(j),ref,:));
        effPerSes{end+1,1} = effV;
        sesAA(end+1,1) = sesV(j);
        subjAA(end+1,1) = subjV(sesV(j));
        
        k = k+1;
    end

end

end

