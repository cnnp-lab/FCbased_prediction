function [outX,outY] = averROC(ROCstruc)
%AVERROC Summary of this function goes here
%   Detailed explanation goes here

X1s = ROCstruc.ROCX1s;
Y1s = ROCstruc.ROCY1s;
X2s = ROCstruc.ROCX2s;
Y2s = ROCstruc.ROCY2s;
percV = ROCstruc.perc;

Y1ref = [];      % Y1 refined
Y2ref = [];      % Y2 refined
for i = 1: length(X1s)
    X1 = X1s{i};
    Y1 = Y1s{i};
    X2 = X2s{i};
    Y2 = Y2s{i};
    
    if length(X1) ~= length(Y1) || length(X2) ~= length(Y2)
        error('incompatible lengths between X and Y')
    end
    
    % subplot(2,1,1)
    % plot(X2,Y2, 's-')
    
    % approximate X1 with X1u which should have no repeated values
    X1u = X1;
    for j = 2: length(X1u)
        if X1u(j) <= X1u(j-1)
            X1u(j) = X1u(j) + j*0.000001;
        end
    end    
    
    % approximate X2 with X2u which should have no repeated values
    X2u = X2;
    for j = 2: length(X2u)
        if X2u(j) <= X2u(j-1)
            X2u(j) = X2u(j) + j*0.000001;
        end
    end
    
    Xcommon = 0:0.001:1;
    Y1_ = interp1(X1u, Y1, Xcommon);
    Y2_ = interp1(X2u, Y2, Xcommon);
    % subplot(2,1,2)
    % plot(Xcommon,Y2_, 's-')
    % title('refined')
    
    Y1ref = [Y1ref; Y1_];
    Y2ref = [Y2ref; Y2_];
    

end

sem1 = std(Y1ref)/ sqrt(size(Y1ref,1));
sem2 = std(Y2ref)/ sqrt(size(Y2ref,1));

rangeUp1 = mean(Y1ref) + sem1;
rangeDo1 = mean(Y1ref) - sem1;

rangeUp2 = mean(Y2ref) + sem2;
rangeDo2 = mean(Y2ref) - sem2;

figure
patch([Xcommon fliplr(Xcommon)], [rangeUp1 fliplr(rangeDo1)], 'k', 'FaceAlpha',.3, 'EdgeColor', 'None')
hold on
patch([Xcommon fliplr(Xcommon)], [rangeUp2 fliplr(rangeDo2)], 'r', 'FaceAlpha',.3, 'EdgeColor', 'None')
plot(Xcommon, mean(Y1ref), 'k')
plot(Xcommon, mean(Y2ref), 'r')
plot([0 1],[0 1], 'k--')
axis square
title(num2str(percV))
set(gcf, 'position',[360   553   196   144])

end

