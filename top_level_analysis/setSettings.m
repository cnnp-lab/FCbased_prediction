absFlag = 0 ;           % abs effect flag
transf = 0;             % transformation of effect
highRespBand = 2;        % optional choice of high responding band
thresh = 2.4;           % threshold for strong effect (2.4 preferred)
bandI = 2;              % chosen band on which to find associations

randInter =1;       % set to 1 to include random intercept

enableLTVs = 0;     % with 1 you enable LTVs, with 2 you enable LTTs

timeWind=9999;     % time window (in hours) after the very first stim session
                    % set to 9999 to disable it (by allowing everything)
                    
specLoc = [];       % specify stim loc: first, second,... use integer