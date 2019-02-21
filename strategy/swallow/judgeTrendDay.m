function tndF = judgeTrendDay(D)
    global g_Swallow_Valid;
    global g_Swallow_Log;
    tndF = 0;
    if ~g_Swallow_Valid
        if isvalid(g_Swallow_Log)
            g_Swallow_Log.printFatal('Error! Swallow License Invalid @ %s', ...
                                     datestr(now));
        end
        return;
    end
    %
    xv = max(D);
    nv = min(D);
    dt = std(D);
    locTndF = 0;
    if (xv - nv > 2*dt)
        if (xv - D(end) < 10) 
            locTndF = 1;
        elseif (D(end) - nv < 10)
            locTndF = -1;
        end
    end
    %
    bhF = buyHoldSwlw(D);
    if (bhF >= 2) || (locTndF > 0)
        tndF = 1;
    elseif (bhF <= -2) || (locTndF < 0)
        tndF = -1;
    else
        tndF = 0;
    end
end