
% For the code sections below you can use the the Run Section tool in 
% Matlab to run one-by-one sequentially 


%% Preprocessing

addpath preprocessing

% Preprocessing step 2: calculate features and extract effect values
calcFeats_script

% remove preprocessing directory from path
rmpath preprocessing


%% Top level analysis
% run Preprocessing first

% Fig 2

% add preprocessing directory to path
addpath top_level_analysis
addpath top_level_analysis/settingsScripts

disp('-- Fig 2 results, delta band')
setSettings_delta
buildLMEuni; clear

disp('-- Fig 2 results, theta band')
setSettings_theta
buildLMEuni; clear


%% Fig 3, delta
% run Preprocessing first

disp('-- Fig 3 results, delta band')
setSettings_delta_LTV
buildLMEuni; clear
setSettings_delta_LTT
buildLMEuni; clear

%% Fig 3, theta
% run Preprocessing first

disp('-- Fig 3 results, theta band')
setSettings_theta_LTV
buildLMEuni
setSettings_theta_LTT
buildLMEuni

%% Fig 4, delta, step-wise forward analysis
% run Preprocessing first
clc
addpath top_level_analysis/stepwiseAnalysis
setSettings_delta
buildLMEuni
close all
stepCompareForward
clear


%% Fig 4, delta, step-wise backward analysis
% run Preprocessing first
clc
addpath top_level_analysis/stepwiseAnalysis
setSettings_delta
buildLMEuni
close all
stepCompareBackward
clear

%% Fig 4, theta, step-wise forward analysis
% run Preprocessing first
clc
addpath top_level_analysis/stepwiseAnalysis
setSettings_theta
buildLMEuni
close all
stepCompareForward
clear


%% Fig 4, theta, step-wise backward analysis
% run Preprocessing first
clc
addpath top_level_analysis/stepwiseAnalysis
setSettings_theta
buildLMEuni
close all
stepCompareBackward
clear


%% Fig 5, delta
% single-channel cross-validated prediction
% this takes several minutes
clc
addpath top_level_analysis/cross_valid_pred
setSettings_delta
buildLMEuni
close all
predLMEchanSingle
predLMEchanSingleStats
clear

%% Fig 5, theta
% single-channel cross-validated prediction
% this takes several minutes
clc
addpath top_level_analysis/cross_valid_pred
setSettings_theta
buildLMEuni
close all
predLMEchanSingle
predLMEchanSingleStats
clear

%% fig 6, delta
% cross-validated prediction on half of the channels in each session
% this takes several minutes
clc
addpath top_level_analysis/cross_valid_pred
setSettings_delta
buildLMEuni
close all
predLMErandHalf
clear

%% fig 6, theta
% cross-validated prediction on half of the channels in each session
% this takes several minutes
clc
addpath top_level_analysis/cross_valid_pred
setSettings_theta
buildLMEuni
close all
predLMErandHalf
clear

%% fig7, delta
% cross-validated prediction on whole set of channels for each session
clc
addpath top_level_analysis/cross_valid_pred
setSettings_delta
buildLMEuni
close all
predLMEwhole
predLMEaucPrc
clear

%% fig7, theta
% cross-validated prediction on whole set of channels for each session
clc
addpath top_level_analysis/cross_valid_pred
setSettings_theta
buildLMEuni
close all
predLMEwhole
predLMEaucPrc
clear