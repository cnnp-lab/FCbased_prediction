function S = preprocL(infoPerSes1,validityMap,distanceMap,subjList,part)
% infoPerSes1 refer to the first column of the infoPerSes in resPerSession_sorted.mat
% it should be in agreement with eff8Map used in the focusOnStim
% similarly with the validityMap


N= length(subjList);

SesV = cell(N,1);
ExpSeq = cell(N,1);
ChanListAll= cell(N,1);
ChanListPerSes= cell(N,1);
StimCh= cell(N,1);
FirstS= cell(N,1);
AvFCs_sq= cell(N,1);
StdFCs_sq = cell(N,1);
VM= cell(N,1);
distV = cell(N,1);
startTV = cell(N,1);
StimLocs = cell(N,1);


progress = 0.1;

for i =1:length(subjList)
    
    if i/length(subjList) > progress
        disp(['Progress:' num2str(100*progress) '% done' ])
        progress = progress+0.1;
    end
    
    [expSeq, chanListAll, stimCh, firstS, startT, chanListPerSes] = loadExpSeq(subjList{i});
    [FCs_lin, avFCs_sq, stdFCs_sq] = calcAverFC(subjList{i}, part);
    
    
    % create vector indicating 1st, 2nd , 3rd... stim loc
    stimChUniq = [];
    for j = 1: length(stimCh)
        if ~isempty(stimCh{j})
            stimChUniq = [stimChUniq; stimCh{j}];
        end
    end
    stimChUniq = unique(stimChUniq,'rows', 'stable');
    stimLocs = zeros(length(stimCh),1);
    for j = 1: length(stimCh)
        if ~isempty(stimCh{j})
            [~,locI] = ismember(stimCh{j}, stimChUniq, 'rows');
            stimLocs(j) = locI;
        end
    end
    

    % find the indices in infoPerSes1 corresponding to the stim sessions
    sesV = [];
    for j = firstS:length(expSeq)
        sesVadd=find(   strcmp(subjList{i} , infoPerSes1(:,1)) &     ...
                        strcmp(expSeq{j}(1:end-2) , infoPerSes1(:,2)) & ...
                        strcmp(expSeq{j}(end) , infoPerSes1(:,3))       ... 
                    );
        sesV = [sesV; sesVadd];
    end
    
    % check whether the non zero values in stimLocs are equal to the sesV
    if nnz(stimLocs) ~= length(sesV)
        error('mismatch, check stimLocs')
    end
    
    %save sesV as it is
    SesV{i} = sesV;
    startTV{i} = startT;
    StimLocs{i} = stimLocs;
    StimCh{i} = stimCh;
    FirstS{i} = firstS;
    AvFCs_sq{i} = avFCs_sq;
    StdFCs_sq{i} = stdFCs_sq;   
    ExpSeq{i} = expSeq;
    ChanListAll{i} = chanListAll;
    
    
    % temporary reduced stimLoc
    stimLocNZ = stimLocs;
    stimLocNZ(stimLocNZ==0)=[];
        
    
    VM{i} = zeros(length(stimLocs), size(validityMap,2));
        
    % get the intersect of validity maps of the sessions in sesV
    % done for each stim loc as in the consistency study
    for j = 1:max(stimLocs)
        sesVLoc = sesV(stimLocNZ==j);
        vm  = logical(validityMap(sesVLoc,:));
        vm = all(vm, 1);
        
        tempI = find(stimLocs==j);
        chanListLoc = chanListPerSes{tempI(1)};
        for jj = 2:length(tempI)
            chanListLoc = intersect(chanListLoc, chanListPerSes{tempI(jj)});
        end

        if sum(vm)~=length(chanListLoc)-2
            error('check chans')
        end
        
     
        for jj = 1: length(stimLocs)
            if stimLocs(jj) == j 
                VM{i}(jj,:) = vm;
                distV{i}{jj,1} = distanceMap(sesVLoc(1), vm);
                ChanListPerSes{i}{jj,1} = chanListLoc;
            end
        end
    end
    
    
end

S = struct( 'SesV', SesV,...
            'VM', VM,...
            'ExpSeq', ExpSeq,...
            'ChanListAll', ChanListAll,...
            'StimCh', StimCh,...
            'FirstS', FirstS,...
            'AvFCs_sq', AvFCs_sq,...
            'distV', distV,...
            'StdFCs_sq', StdFCs_sq,...
            'startTV', startTV,...
            'StimLocs', StimLocs,...
            'ChanListPerSes', ChanListPerSes );