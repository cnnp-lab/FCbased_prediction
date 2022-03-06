function [features, LTVs, LTTs, tSince, stimLocs, chanListRef]=extrFeatures(S)
% features:
% 1. distance
% 2. anode FC
% 3. cathode FC
% 4. z-scored FC (anode-cathode combination) 
% 5. short-term SD of anode FC
% 6. short-term SD of cathode FC
% 7. z-scored short-term SD of FC (anode-cathode combination)
% 8. long-term SD of FC


features = {};
LTVs = {};
LTTs = {};
tSince = []; % time since the very first stim session (in hours)
stimLocs = [];
chanListRef = {}; %channel list refined, what is used afterall
numSubj = length(S);

% % maximal index of stimSession for each subject
% maxStimSesI = zeros(numSubj, 1);

for i =1:numSubj
    
    expSeq = S(i).ExpSeq;
    chanListAll = S(i).ChanListAll;
    chanListSes = S(i).ChanListPerSes;
    stimCh = S(i).StimCh;
    firstS = S(i).FirstS;
    avFCs_sq = S(i).AvFCs_sq;
    distv= S(i).distV;
    stdFCs_sq = S(i).StdFCs_sq;
    starttv = S(i).startTV;

    
    currStimLocs = S(i).StimLocs;
    stimSes = find(currStimLocs);
    
    if length(expSeq) ~= length(starttv)
        warning('discrepancies found')
    end

        
    
    if find(chanListAll == 0)
        error('channel 0 found')
    end
    nExp = length(expSeq);

    nFCs = size(avFCs_sq,1);
    
    if nFCs>nExp
        warning('number of FCs higher than the number of experiments. ')
        error('FCs from both start and end of session?')
    end
    
    % reduce the expSeq to the first nFC experiments
    expSeq = expSeq(1:nFCs);

    % % mark the stim sessions in the sequence
    % stimSesInSeq = zeros(size(expSeq));
    % for j = 1 : length(expSeq)
    %     curr =  str2double(expSeq{j}(end-2));
    %     if curr>1
    %         stimSesInSeq(j) = 1;
    %     end
    % end
    % stimSessions = find(stimSesInSeq);
    % maxStimSesI(i) =  stimSessions(end);
    
    for j = 1 :length(stimSes)
    
        % channel list without the stim channels
        chanList_woStim = setdiff(chanListSes{stimSes(j)}, stimCh{stimSes(j)});
        if length(chanList_woStim)~= length(chanListSes{stimSes(j)}) - 2
            error('check length of chanList')
        end


        currChSubset = ismember(chanListAll, chanList_woStim);
        [~,stimIinFC] = ismember(stimCh{firstS}, chanListAll);

        % only the stim channels in FC
        avFCs_sq_st = avFCs_sq(:, stimIinFC, currChSubset);
        anodFC= squeeze(avFCs_sq_st(:,1,:));
        cathFC= squeeze(avFCs_sq_st(:,2,:));

        % only the stim channels in FC
        stdFCs_sq_st = stdFCs_sq(:, stimIinFC, currChSubset);
        SDanodFC= squeeze(stdFCs_sq_st(:,1,:));
        SDcathFC= squeeze(stdFCs_sq_st(:,2,:));


        % transform to zscore
        FC_z = zeros(2, size(avFCs_sq_st,3), nFCs);
        SDFC_z = zeros(2, size(avFCs_sq_st,3), nFCs);
        for jj = 1: nFCs
            FC_z(:,:,jj) = zscoreNaNs(squeeze(avFCs_sq_st(jj,:,:)));
            SDFC_z(:,:,jj) = zscoreNaNs(squeeze(stdFCs_sq_st(jj,:,:)));
        end

        % get some zscore statistics across all sessions (only for FC)
        % std and mean of zscores (no absolute values here)
        % considering both anode and cathode
        FC_z_reshape = [squeeze(FC_z(1,:,:)) squeeze(FC_z(2,:,:))];
        longtermSD = zeros(size(FC_z_reshape,1), nFCs);
        %stdDeriv = zeros(size(FC_z_reshape,1), nFCs);
        for jj = 1:nFCs
            longtermSD(:,jj) = std(FC_z_reshape(:, 1:2*jj), 0, 2);
            % stdDeriv(:,jj) = std(diff(FC_z_reshape(:, 1:2*jj), 1, 2), 0, 2);
        end
        % stdDeriv(stdDeriv==0)=1;


        H = [99 5:-1:0];
        nH = length(H);
        %longtermSD2 = zeros(size(FC_z_reshape,1), nH, length(stimSes));
        longtermSD2 = zeros(size(FC_z_reshape,1), nH);

        for k = 1:nH
            %longtermSD2(:,k,j) = getLTV( FC_z_reshape(:,1:2*stimSes(j)), H(k));
            longtermSD2(:,k) = getLTV( FC_z_reshape(:,1:2*stimSes(j)), H(k));
        end


        hstep = 24;
        stepsback = 7;
        H = [999 stepsback*hstep : -hstep : 0];
        nH = length(H);
        % longtermSD3 = zeros(size(FC_z_reshape,1), nH, length(stimSes));
        longtermSD3 = zeros(size(FC_z_reshape,1), nH);

        for k = 1:nH
            longtermSD3(:,k)= getLTT( FC_z_reshape(:,1:2*stimSes(j)),...
                                    H(k), starttv(1:stimSes(j)));
        end



        % get the stim sessions subset
        subFC_z = FC_z(:,:,stimSes(j));
        subSDFC_z = SDFC_z(:,:,stimSes(j));
        subanodFC = anodFC(stimSes(j),:);
        subcathFC = cathFC(stimSes(j),:);
        subanodsFC = SDanodFC(stimSes(j),:);
        subcathsFC = SDcathFC(stimSes(j),:);

        
        % % get the stim session only for WT (alternative FCsM)
        % wts = squeeze(wt(stimSes(j),:,:));
        % wtsq=[];
        % for klj = 1: 30
        %     wtsq(:,:,klj) = squareform(wts(:,klj));
        % end
        % % get only anode cathode from the square
        % wtsq_st = wtsq( stimIinFC, currChSubset, :);
        % % z-score separately anode, cathode
        % wtsq_st_z=[];
        % for klj = 1: 30
        %     wtsq_st_z(:,:,klj) = zscoreNaNs(wtsq_st(:,:,klj));
        % end
        % % this needs to be transformed from 2x nCh x 30 to nCh x 60
        % wtsq_st_zz = [squeeze(wtsq_st_z(1,:,:))  squeeze(wtsq_st_z(2,:,:))];
        % % std across the blocks of both anode and cathode
        % wtsq_st_zz_std = std(wtsq_st_zz, 0, 2);
        
        
        % mean of absolute zscore between anode cathode
        zFC = squeeze(mean(abs(subFC_z))); 
        zSDFC = squeeze(mean(abs(subSDFC_z)));
        if size(zFC,1)==1
            zFC = zFC';
            zSDFC = zSDFC';
        end
    
        
        if length(chanListAll(currChSubset))<30
            % too few channels left in this session... skipping session
            continue
        end
        
        chanListRef{end+1,1} = chanListAll(currChSubset);
        
        currDistv = distv{stimSes(j)}(ismember( chanList_woStim, chanListAll));
        
        features{end+1,1}(:,1) = (1./currDistv)';
        features{end,1}(:,2) = subanodFC';
        features{end,1}(:,3) = subcathFC';
        features{end,1}(:,4) = zFC;
        features{end,1}(:,5) = subanodsFC';
        features{end,1}(:,6) = subcathsFC';
        features{end,1}(:,7) = zSDFC;               
        %features{end,1}(:,7) = wtsq_st_zz_std;  %alternative FCsM disabled
        features{end,1}(:,8) = longtermSD(:,stimSes(j));
        %features{end,1}(:,8) = longtermSD2(:,end,j);      % enable H0 temp
        
        LTVs{end+1,1} = longtermSD2;
        LTTs{end+1,1} = longtermSD3;
        
        % time since the very first stim session 
        tSince(end+1,1) = (starttv(stimSes(j)) - starttv(stimSes(1)))...
                            /(1000*60*60);
                        
        stimLocs(end+1,1) = currStimLocs(stimSes(j));       
        
    end
end


% histogram(maxStimSesI-1, 25)
% hold on
% stem(6.5, 10)
% title('number of sessions before the last session')
% legend(num2str(sum([maxStimSesI-1]<6.5)/length(maxStimSesI)))
end

