
% First you need to run the SCperSubj script to produce the SC.mat
% this will also find the white matter (WM) electrodes
% these electrodes need to be removed from the FC matrices before 
% calculating the features

% load the SC for each subject in subjList
load('SC.mat', 'WMcell','SC', 'SCxWM')

%load the pre-preprocessing results which include the FC preprocessing
load preproc_output1.mat


[features,LTVs,LTTs,tSince,stimLoc,chanListRef] = extrFeatures(S);
                       

%  3 of the SC features are very correlated between them
% keep only the first two
chosenSCfeatures = [1,2];
features = addSCfeatures(features,SC,chosenSCfeatures);



% extract the effect matrices
[effPerSes, sesAA, subjAA] = extrEffPerSes(eff8Map,{S.SesV},chanListRef, subjV, tSince);



clear distanceMap eff8Map validityMap infoPerSes subjV i tWM WMchID sI S
clear exclWM chosenSCfeatures
save preproc_output2.mat
clear