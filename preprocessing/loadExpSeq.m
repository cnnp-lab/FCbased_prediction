function [expSeq, chanListAll, stimCh, firstStimSes, expStartT,chanListPerSes] = loadExpSeq(subjS)
%LOADMATS Summary of this function goes here
%   Detailed explanation goes here
if ismac
    load(['/Users/chris/OneDrive - Newcastle University/RAManalysis/perSubject/' subjS '/allExpSamples/M.mat'])
    load(['/Users/chris/OneDrive - Newcastle University/RAManalysis/perSubject/' subjS '/expSeq.mat'])
else
    load(['C:\Users\ncp112\OneDrive - Newcastle University\RAManalysis\perSubject\' subjS '\allExpSamples\M.mat'])
    load(['C:\Users\ncp112\OneDrive - Newcastle University\RAManalysis\perSubject\' subjS '\expSeq.mat'])
end

% assuming that only one part of the session is considered (start/end)
expSeq = expSeq(1: (size(Mdf,1)/2));
% stimCh = stimCh{firstStimSes};
end

