% load necessary information about each session
load('resPerSession_sorted.mat', 'validityMap', 'eff8Map', 'infoPerSes',... 
    'distanceMap', 'subjV')

% load list of subjects used in this study
load('subject_subset.mat')

% preprocess to extract useful information for feature calculation later on
% subject-wise preprocessing results saved in structure S
S = preprocL(infoPerSes,validityMap,distanceMap,subjList,1);

% remove variables not useful anymore
clear validityMap infoPerSes distanceMap subjList

% save the rest
save preproc_output1.mat
clear