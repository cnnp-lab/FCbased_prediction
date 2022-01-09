function LTT = getLTT(FCmatrix, H, startT)
%GETLTV computes the long-term variability of FC for the last session
%
% The FCmatrix is expected to have even number of columns 2 x nSes
% (anode and cathode) for each sessions 
% The last 2 columns of FCmatrix refer to the last session
%
% The number of rows equals the channels
%
% The history parameter H dictates how far back in time the algorithm goes
% to compute the long term variability of the last session.
% For H=0 the long-term variability is actually just the standard deviation
% of the anode and cathode in the last session.
% For H=X>0 the long-term variability is computed aftre the inclusion of X
% sessions before the last session.
% If X is higher than the available number of sessions, then it takes all
% the sessions. So for a very high value of X, say 99, it will always take
% all the available sessions.

H = floor(H);
if H < 0
    error('parameter H cannot be negative')
end

% reverse in time the FC matrix, last session comes first (first 2 columns)
FCmatrix = FCmatrix(:, end:-1:1);

% time difference (in hours ) between session i and last session
dt =  (startT(end)- startT(1:end-1))/(60*60*1000);

if ~issorted(dt,'descend')
    error('not sorted dt')
end


% count how many sessions are within H hours
b = sum(dt<H);

% up to which index to be used
upTo = b*2 + 2;

% calculate long-term variability
LTT = std(FCmatrix(:, 1:upTo), 0, 2);


end

