function eq = formEq(vNames, response, pI, randFlag)
%FORMEQ Summary of this function goes here
%   Detailed explanation goes here



if length(pI)<1
    error('give one or more predictors')
end

eq = [response '~' vNames{pI(1)}];

for j = 2: length(pI)
    eq = [eq '+' vNames{pI(j)}];
end

if randFlag
    eq = [eq '+(1|session)'];
end

end

