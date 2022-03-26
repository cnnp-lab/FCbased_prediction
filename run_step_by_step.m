
% For the code sections below you can use the the Run Section tool in 
% Matlab to run one-by-one sequentially 


%% Preprocessing

addpath preprocessing
addpath top_level_analysis
addpath top_level_analysis/settingsScripts

% Preprocessing: calculate features and extract effect values
calcFeats_script

% remove preprocessing directory from path
rmpath preprocessing


%% Top level analysis
% run Preprocessing first

% Fig 2

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
setSettings_theta_LTV  % preceding sessions considered for FCL
buildLMEuni
setSettings_theta_LTT  % preceding days considered for FCL
buildLMEuni

%% Fig 4, delta, step-wise forward analysis
% run Preprocessing first

% the labels used in the printed equations (describing the models)
% correspond to the labels used in the figures as follows:
% distance FC2  FC3  FC4  FC5  FC6  FC7  FC8  SC1   SC2
%   D      FCA  FCC  FCM  FCsA FCsC FCsM FCL  SCslc SCgfa

clc
addpath top_level_analysis/stepwiseAnalysis
setSettings_delta
buildLMEuni
close all
stepCompareForward
clear


%% Fig 4, delta, step-wise backward analysis
% run Preprocessing first

% the labels used in the printed equations (describing the models)
% correspond to the labels used in the figures as follows:
% distance FC2  FC3  FC4  FC5  FC6  FC7  FC8  SC1   SC2
%   D      FCA  FCC  FCM  FCsA FCsC FCsM FCL  SCslc SCgfa

clc
addpath top_level_analysis/stepwiseAnalysis
setSettings_delta
buildLMEuni
close all
stepCompareBackward
clear

%% Fig 4, theta, step-wise forward analysis
% run Preprocessing first

% the labels used in the printed equations (describing the models)
% correspond to the labels used in the figures as follows:
% distance FC2  FC3  FC4  FC5  FC6  FC7  FC8  SC1   SC2
%   D      FCA  FCC  FCM  FCsA FCsC FCsM FCL  SCslc SCgfa

clc
addpath top_level_analysis/stepwiseAnalysis
setSettings_theta
buildLMEuni
close all
stepCompareForward
clear


%% Fig 4, theta, step-wise backward analysis
% run Preprocessing first

% the labels used in the printed equations (describing the models)
% correspond to the labels used in the figures as follows:
% distance FC2  FC3  FC4  FC5  FC6  FC7  FC8  SC1   SC2
%   D      FCA  FCC  FCM  FCsA FCsC FCsM FCL  SCslc SCgfa

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