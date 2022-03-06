function [B] = trialByTrialCorr(A)
%TRIALBYTRIALCORR Summary of this function goes here
%   A has 3 dimensions: channels x trials x time
%   B has 2 dimensions: nchoosek(channels,2) x trials 

B = zeros(nchoosek(size(A,1),2),size(A,2));

for currTrial = 1:size(A,2)
    C = squeeze(A(:,currTrial,:))';
    D = corr(C);
    D(isnan(D))=0;
    D = D .* ~eye(size(D));
    B(:,currTrial) = squareform(D)';
end
end

