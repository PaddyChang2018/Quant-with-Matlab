function Ops = tiger(H,L,Prc,LongLot,LongPrc,ShortLot,ShortPrc, ...
                                         MaxTotalLot,LotPerTrd)
    global g_Tiger_Valid;
    global g_Tiger_Log;
    % Initial return values
    LongOP = 0;
    ShortOP = 0;
    % Check license valid
    if ~g_Tiger_Valid
        Ops = [LongOP,ShortOP];
        if isvalid(g_Tiger_Log)
            g_Tiger_Log.printFatal('Error! Tiger License Invalid @ %s', ...
                                   datestr(now));
        end
        return;
    end
    %
    if nargin == 7
        MaxTotalLot = 1;
        LotPerTrd = 1;
    elseif nargin == 8
        LotPerTrd = 1;
    end
    % check parameters
    if (LongLot > 0 && LongPrc == 0) || ...
       (ShortLot > 0 && ShortPrc == 0) || ...
       (length(H) < 48) || (length(H) ~= length(L))
        Ops = [LongOP,ShortOP];
        g_Tiger_Log.printFatal('Error! Check Input Parameters Failed @ %s', ...
                               datestr(now));
        return;
    end
    %
    mdl = arima('Constant',0,'ARLags',1,'D',1);
    HL = (H + L)/2;
    trSpl = HL(end-47:end-12);
    try
        est = estimate(mdl,trSpl,'Display','off');
    catch
        Ops = [LongOP,ShortOP];
        g_Tiger_Log.printFatal('Error! Estimate Model Parameters Error @ %s', ...
                               datestr(now));
        return;
    end
    %
    ftN = 24;
    simN = 2000;
    cmpS = HL(end-11:end);
    Yset = simulate(est,ftN,'NumPaths',simN,'Y0',trSpl);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % R2016b 64bit
    %res = (Yset(1:12,:) - cmpS) .^ 2;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % R2015b 32bit
    res = (Yset(1:12,:) - repmat(cmpS,1,simN)) .^ 2;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [mse,mseIdx] = min(sum(res));
    mde = abs(Yset(12,mseIdx) - cmpS(end));
    if (mse > 50) || ( mde > 5) 
        Ops = [LongOP,ShortOP];
        g_Tiger_Log.printFatal('Warning! Model Simulation Outfit : mse(%0.2f), mde(%0.2f) @ %s', ...
                               mse,mde,datestr(now));
        return;
    end
    %
    delta = std(HL);
    if delta < 10
        delta = 10;
    end
    %
    Y = Yset(13:end,mseIdx);
    maxY = max(Y);
    minY = min(Y);
    % Close Long Position
    if LongLot > 0 
        if ((Prc > LongPrc) && (minY < Prc - delta || Y(end) < Y(1) - delta)) || ...
           (Prc > LongPrc + 1.5*delta)
            LongOP = -LongLot;
            g_Tiger_Log.printInfo('Close Long Position : %d lot @ %s', ...
                                  LongLot,datestr(now));
        end
    end
    % Close Short Position
    if ShortLot > 0
        if ((Prc < ShortPrc) && (maxY > Prc + delta || Y(end) > Y(1) + delta)) || ...
           (Prc < ShortPrc - 1.5*delta)
            ShortOP = -ShortLot;
            g_Tiger_Log.printInfo('Close Short Position : %d lot @ %s', ...
                                  ShortLot,datestr(now));
        end
    end
    % Open Long Position
    if (Y(end) > Prc + delta) && (Y(end) > Y(1) + delta) && ...
       (Y(1) - minY < maxY - Y(1) - delta) && (maxY - Y(end) < 0.5*delta)
        if (LongLot + LotPerTrd) <= MaxTotalLot 
            LongOP = LotPerTrd;
            g_Tiger_Log.printInfo('Open Long Position : %d lot @ %s', ...
                                  LotPerTrd,datestr(now));
        end
    end
    % Open Short Position
    if (Y(end) < Prc - delta) && (Y(end) < Y(1) - delta) && ...
       (maxY - Y(1) < Y(1) - minY - delta) && (Y(end) - minY < 0.5*delta)
        if (ShortLot + LotPerTrd) <= MaxTotalLot
            ShortOP = LotPerTrd;
            g_Tiger_Log.printInfo('Open Short Position : %d lot @ %s', ...
                                  LotPerTrd,datestr(now));
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ops = [LongOP,ShortOP];
end