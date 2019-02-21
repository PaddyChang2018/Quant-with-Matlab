function [tndF,bhV] = buyHold(S)
    %vTbl = [50 35 20;80 55 30;100 70 40;120 80 45];
    vTbl = [40 30 15;80 55 30;100 70 40;120 80 45];
    %
    lenS = length(S);
    if lenS > size(vTbl,1) * 100
        tndF = 0;
        bhV = 0;
        return;
    end
    %
    rowIdx = floor(lenS/100);
    pct = lenS/100 - rowIdx;
    if pct > 0
        threshold = vTbl(rowIdx,:) + (vTbl(rowIdx+1,:) - vTbl(rowIdx,:)) * pct;
    else
        threshold = vTbl(rowIdx,:);
    end
    %
    bhV = mean(S(end) - S(1:end-1));
    if bhV > threshold(1,1)
        tndF = 3;
    elseif  bhV > threshold(1,2)
        tndF = 2;
    elseif bhV > threshold(1,3)
        tndF = 1;
    elseif bhV < -threshold(1,1)
        tndF = -3;
    elseif bhV < -threshold(1,2)
        tndF = -2;
    elseif bhV < -threshold(1,3)
        tndF = -1;
    else
        tndF = 0;
    end
end