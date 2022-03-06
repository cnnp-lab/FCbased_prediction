function [Z, a] = zscoreNaNs(A)
%UNTITLED Summary of this function goes here
%   A should be 2d matrix or vector
% based on means calculated for each row
% nans are omitted in the calculations

if length(size(A))>2
    error('multi dim matrix')
end

mus = mean(A, 2, 'omitnan' );
sigmas = std(A, 0, 2, 'omitnan' );

Z = (A-mus)./sigmas;
a = (A-mus);
end

