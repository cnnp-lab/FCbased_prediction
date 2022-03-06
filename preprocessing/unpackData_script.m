% load necessary information about each session
load('dataPerSession_sorted.mat', ...
        'validityMap',... 
        'eff8Map', ...
        'infoPerSes',... 
        'distanceMap',... 
        'subjV')

% load list of subjects used in this study
load('subject_subset.mat')

% display current status
disp('-- Unpacking and reorganizing data started...')

% Extract useful information for feature calculation later on
% Subject-wise preprocessing results saved in structure S
S = preprocL(infoPerSes,validityMap,distanceMap,subjList,1);

% remove variables not useful anymore
clear validityMap infoPerSes distanceMap subjList

% save the rest
save preproc_output1.mat

% display current status
disp('-- Finished unpacking and reorganizing data')

clear