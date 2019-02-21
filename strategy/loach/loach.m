function ret = loach(open,high,low,close,volume)
    direct = 0;
    stoploss = 0;
    if length(volume) < 30
        ret = [direct,stoploss];
        return;
    end
    muvol = mean(volume(end-10:end-3));
    mxvol = max(volume(end-2:end));
    if ( mxvol > (muvol * 2)) && (mxvol > 20000)
        [hv,hi] = max(high);
        [lv,li] = min(low);
        ev = close(end);
        if hi < li % down trend
            if (ev - lv >= 20)  && (mean(close(end-2:end) - open(end-2:end)) <= 2) % up trend(little)
                direct = -1;
                stoploss = ev + 10;
            elseif (hv - ev >= 20) && (ev - lv <= 3) && ...
                   (mean(close(end-2:end) - open(end-2:end) >= -2))  % down trend
                direct = 1;
                stoploss = ev - 10;
            end
        else       % up trend
            if (hv - ev >= 20) && (mean(close(end-2:end) - open(end-2:end)) >= -2) % down trend
                direct = 1;
                stoploss = ev - 10;
            elseif (ev - lv >= 20) && (hv - ev <= 3) && ...
                   (mean(close(end-2:end) - open(end-2:end)) <= 2) % up trend
                direct = -1;
                stoploss = ev + 10;
            end
        end
    end
    ret = [direct,stoploss];
end