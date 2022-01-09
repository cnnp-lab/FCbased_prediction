function features = addSCfeatures(features,SC,chosenSCfeatures)
%ADDSCFEATURES Summary of this function goes here
%   Detailed explanation goes here


for i = 1:length(features)
    features{i} = [features{i} SC{i}(:,chosenSCfeatures)];
end

end

