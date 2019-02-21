function Ops = pigeon(Price,LongLot,ShortLot,MaxTotalLot,LotPerTrd)
    global g_Pigeon_Valid;
    global g_Pigeon_Log;
%     global g_Pigeon_IP;
    % Initial return values
    LongOP = 0;
    ShortOP = 0;
    % Check License Valid
    if ~g_Pigeon_Valid
        if isvalid(g_Pigeon_Log)
            g_Pigeon_Log.printFatal('Error! Pigeon License Invalid @ %s', ...
                                     datestr(now));
        end
        Ops = [LongOP,ShortOP];
        return;
    end
    % 
    if nargin == 3
        MaxTotalLot = 1;
        LotPerTrd = 1;
    elseif nargin == 4
        LotPerTrd = 1;
    end
    % Check Input Parameters
    if (length(Price) < 500) || (MaxTotalLot < LotPerTrd)
        g_Pigeon_Log.printFatal('Error! Check Input Parameters Failed @ %s', ...
                                 datestr(now));
        Ops = [LongOP,ShortOP];
        return;
    end
    %
    S = Price(end-499:end);
    [C,L] = wavedec(S,9,'coif5');
    fast = wrcoef('a',C,L,'coif5',5);
    slow = wrcoef('a',C,L,'coif5',7);
    d6 = wrcoef('d',C,L,'coif5',6);
    d7 = wrcoef('d',C,L,'coif5',7);
    D = d6 + d7;
    DI = gradient(D,0.05);
    slowI = gradient(slow,0.05);
    %
    rngSlow = range(slow);
    dlt = slow(end) - min(slow);
    if rngSlow <= 100     % small volatility
        % follow trend
        if (S(end) > fast(end)) && (fast(end) > slow(end) + 2) && (slow(end) > slow(end-5))
            if (DI(end) > 0) && (D(end) > 3) 
                ShortOP = -ShortLot;
                if (LongLot + LotPerTrd) <= MaxTotalLot
                    LongOP = LotPerTrd;        
                end
                Ops = [LongOP,ShortOP];
                return;
            end
        elseif (S(end) < fast(end)) && (fast(end) < slow(end) - 2) && (slow(end) < slow(end-5))
            if (DI(end) < 0) && (D(end) < -3)
                LongOP = -LongLot;
                if (ShortLot + LotPerTrd) <= MaxTotalLot
                    ShortOP = LotPerTrd;        
                end
                Ops = [LongOP,ShortOP];
                return;
            end
        end
        % reverse trend
        if (dlt < rngSlow * 0.2)  
            if (fast(end) > slow(end)+2) && (S(end) > fast(end)) && (slow(end) > slow(end-5))
                if (D(end) > 3) && (DI(end) > 0) && (slowI(end) > 0.5) 
                    ShortOP = -ShortLot;
                    if (LongLot + LotPerTrd) <= MaxTotalLot
                        LongOP = LotPerTrd;        
                    end
                    Ops = [LongOP,ShortOP];
                    return;
                end
            end
        elseif (dlt > rngSlow * 0.8) 
            if (fast(end) < slow(end)-2) && (S(end) < fast(end)) && (slow(end) < slow(end-5))
                if (D(end) < -3) && (DI(end) < 0) && (slowI(end) < -0.5)
                    LongOP = -LongLot;
                    if (ShortLot + LotPerTrd) <= MaxTotalLot
                        ShortOP = LotPerTrd;        
                    end
                    Ops = [LongOP,ShortOP];
                    return;
                end
            end
        end
    end
    % return operation
    Ops = [LongOP,ShortOP];
    %---------------------------------------------------------------------------
    % Record Operations in log file and mail to Paddy
    %---------------------------------------------------------------------------
%     if LongOP > 0
%         tmS = datestr(now);
%         g_Pigeon_Log.printInfo('Open Long Position %d Lot @ %s', ...
%                                 LongOP,tmS);
%         msg = sprintf('The pigeon strategy open %d lot long position at %s.\n\n%s', ...
%                       LongOP,tmS,g_Pigeon_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Pigeon Open Long Position',msg);
%     elseif LongOP < 0 
%         tmS = datestr(now);
%         g_Pigeon_Log.printInfo('Close Long Position %d Lot @ %s', ...
%                                 -LongOP,tmS);
%         msg = sprintf('The pigeon strategy close %d lot long position at %s.\n\n%s', ...
%                       -LongOP,tmS,g_Pigeon_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Pigeon Close Long Position',msg);
%     end
%     if ShortOP > 0
%         tmS = datestr(now);
%         g_Pigeon_Log.printInfo('Open Short Position %d Lot @ %s', ...
%                                 ShortOP,tmS);
%         msg = sprintf('The pigeon strategy open %d lot short position at %s.\n\n%s', ...
%                       ShortOP,tmS,g_Pigeon_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Pigeon Open Short Position',msg);
%     elseif ShortOP < 0
%         tmS = datestr(now);
%         g_Pigeon_Log.printInfo('Close Short Position %d Lot @ %s', ...
%                                 -ShortOP,tmS);
%         msg = sprintf('The pigeon strategy close %d lot short position at %s.\n\n%s', ...
%                       -ShortOP,tmS,g_Pigeon_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Pigeon Close Short Position',msg);
%     end
end