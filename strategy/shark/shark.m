function ret = shark(open,high,low,close,volume,sftNum)
    direct = 0;
    stoploss = 0;
    len = length(open) - sftNum + 1;
    nopen = zeros(len,1);
    nhigh = zeros(len,1);
    nlow = zeros(len,1);
    nclose = zeros(len,1);
    %
    j = 1;
    for i = sftNum : length(open)
        nopen(j) = open(i-sftNum+1);
        nhigh(j) = max(high(i-sftNum+1:i));
        nlow(j) = min(low(i-sftNum+1:i));
        nclose(j) = close(i);
        j = j + 1;
    end
    %
    muvol = mean(volume(end-10 : end-3));
    mxvol = max(volume(end-2:end));
    %
    if (nclose(end) > nopen(end)) &&  (nhigh(end) > nhigh(end-1)) && ...
       (nhigh(end) - nclose(end) <= 3)
        cdlLen = close(end) - nlow(end);
        if (cdlLen > 25) && (mxvol > 2 * muvol) && ...
           (abs(open(end) - close(end)) <= 4)
            direct = -1;            % revert
            stoploss = nclose(end) + 10;
        elseif (cdlLen < 15) && (abs(open(end) - close(end)) >= 8)
            direct = 1;             % up break out
            stoploss = nclose(end) - 10;
        end
    elseif (nclose(end) < nopen(end)) && (nlow(end) < nlow(end-1)) && ...
           (nclose(end) - nlow(end) <= 3)
        cdlLen = nhigh(end) - close(end);
        if (cdlLen > 25) && (mxvol > 2 * muvol) && ...
           (abs(open(end) - close(end)) <= 4)
            direct = 1;             % revert
            stoploss = nclose(end) - 10;
        elseif (cdlLen < 15) && (abs(open(end) - close(end)) >= 8)
            direct = -1;            % down break out
            stoploss = nclose(end) + 10;
        end
    end
    %
    ret = [direct,stoploss,nopen(end),nhigh(end),nlow(end),nclose(end)];
end