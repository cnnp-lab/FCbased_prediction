function [FCs_lin, avFCs_sq, stdFCs_sq] = calcAverFC(subjS, part)
% calculate the average FCs and their std for subjS
% considering that there are 60 sec segments, FC is calculated for each 2
% sec block and then the average is calculated from the 30 blocks.
% It loads, analyses and exports either all epochs/sessions or just the
% beginning (part=1) or end (part=2) epochs.
% It returns the FCs in square form (3D)

if ismac
    load(['/Users/chris/OneDrive - Newcastle University/RAManalysis/perSubject/' subjS '/allExpSamples/M.mat'])
    %load(['/Users/chris/OneDrive - Newcastle University/RAManalysis/perSubject/' subjS '/expSeq.mat'])
else
    load(['C:\Users\ncp112\OneDrive - Newcastle University\RAManalysis\perSubject\' subjS '\allExpSamples\M.mat'])
    %load(['C:\Users\ncp112\OneDrive - Newcastle University\RAManalysis\perSubject\' subjS '\expSeq.mat'])
end


% get only the beginning (part=1) or end(part=2) of sessions
if part
    Mdf = Mdf(part:2:end, :,:);
end

% as it is, it has the form  exp x channels x time
nExp = size(Mdf,1);
nSamples = size(Mdf,3);
nBlocks = 30;
remainder = mod(nSamples,nBlocks);   % 30 blocks of 2s (assuming 60s total)
if remainder>3
    error('large remainder')
end
Mdf = Mdf(:,:,1:end-remainder); % remove a small remainder (if any)

for i = 1 : nExp
    currExp = squeeze(Mdf(i,:,:));
    
    currExp = reshape(currExp, [size(currExp,1) size(currExp,2)/nBlocks nBlocks]);
    
    % permute the dimensions 
    % from chan x time x block   to   chan x block x time
    currExp = permute(currExp, [1 3 2]);
    
    % feeding in the matrix in trialByTrialCorr as: channels x block x time
    % the output is: nchoosek(channels,2) x block 
    FCs_lin(i,:,:) = trialByTrialCorr(currExp); 
    avFCs_lin(i,:) = mean(FCs_lin(i,:,:), 3);       % aver. across blocks
    stdFCs_lin(i,:) = std(FCs_lin(i,:,:), 0, 3);    % std. across blocks
end



for i = 1 : nExp
    avFCs_sq(i,:,:) = squareform(avFCs_lin(i,:));
    stdFCs_sq(i,:,:) = squareform(stdFCs_lin(i,:));
end



