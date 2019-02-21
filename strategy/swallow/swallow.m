function Ops = swallow(Price,LongLot,ShortLot,MaxTotalLot,LotPerTrd)
    global g_Swallow_Valid;
    global g_Swallow_Log;
%     global g_Swallow_IP;
    % Initial return values
    LongOP = 0;
    ShortOP = 0;
    % Check License Valid
    if ~g_Swallow_Valid
        if isvalid(g_Swallow_Log)
            g_Swallow_Log.printFatal('Error! Swallow License Invalid @ %s', ...
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
    if (length(Price) < 300) || (MaxTotalLot < LotPerTrd)
        g_Swallow_Log.printFatal('Error! Check Input Parameters Failed @ %s', ...
                                 datestr(now));
        Ops = [LongOP,ShortOP];
        return;
    end
    % Just for test in runSwallow output chart
%     LongOP = -LongLot;
%     ShortOP = -ShortLot;
    rS = price2ret(Price(end-299:end)) * 100;
    dlt = std(rS(1:end-1));
    if abs(rS(end)) > dlt
        invRS = flipud(rS(end-100:end-1));
        fst = find(abs(invRS) > dlt,1);
        if fst <= 6
            updn = 0;
        else
            updn = sum(invRS(1:fst-1));
        end
        if updn > 0 && rS(end) > 0 && invRS(fst) > 0
            ShortOP = -ShortLot;
            if (LongLot + LotPerTrd) <= MaxTotalLot
                LongOP = LotPerTrd;        
            end
        elseif updn < 0 && rS(end) < 0 && invRS(fst) < 0
            LongOP = -LongLot;
            if (ShortLot + LotPerTrd) <= MaxTotalLot
                ShortOP = LotPerTrd;        
            end
        end
    end
    %---------------------------------------------------------------------------
    % return operation
    %---------------------------------------------------------------------------
    Ops = [LongOP,ShortOP];
    %---------------------------------------------------------------------------
    % Record Operations in log file and mail to Paddy
    %---------------------------------------------------------------------------
%     if LongOP > 0
%         tmS = datestr(now);
%         g_Swallow_Log.printInfo('Open Long Position %d Lot @ %s', ...
%                                 LongOP,tmS);
%         msg = sprintf('The swallow strategy open %d lot long position at %s.\n\n%s', ...
%                       LongOP,tmS,g_Swallow_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Swallow Open Long Position',msg);
%     elseif LongOP < 0 
%         tmS = datestr(now);
%         g_Swallow_Log.printInfo('Close Long Position %d Lot @ %s', ...
%                                 -LongOP,tmS);
%         msg = sprintf('The swallow strategy close %d lot long position at %s.\n\n%s', ...
%                       -LongOP,tmS,g_Swallow_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Swallow Close Long Position',msg);
%     end
%     if ShortOP > 0
%         tmS = datestr(now);
%         g_Swallow_Log.printInfo('Open Short Position %d Lot @ %s', ...
%                                 ShortOP,datestr(now));
%         msg = sprintf('The swallow strategy open %d lot short position at %s.\n\n%s', ...
%                       ShortOP,tmS,g_Swallow_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Swallow Open Short Position',msg);
%     elseif ShortOP < 0
%         tmS = datestr(now);
%         g_Swallow_Log.printInfo('Close Short Position %d Lot @ %s', ...
%                                 -ShortOP,tmS);
%         msg = sprintf('The swallow strategy close %d lot short position at %s.\n\n%s', ...
%                       -ShortOP,tmS,g_Swallow_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Swallow Close Short Position',msg);
%     end
end