function Ops = sparrow(Price,LongLot,ShortLot,MaxTotalLot,LotPerTrd)
    global g_Sparrow_Valid;
    global g_Sparrow_Log;
%     global g_Sparrow_IP;
    % Initial return values
    LongOP = 0;
    ShortOP = 0;
    % Check License Valid
    if ~g_Sparrow_Valid
        Ops = [LongOP,ShortOP];
        if isvalid(g_Sparrow_Log)
            g_Sparrow_Log.printFatal('Error! Sparrow License Invalid @ %s', ...
                                     datestr(now));
        end
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
        Ops = [LongOP,ShortOP];
        g_Sparrow_Log.printFatal('Error! Check Input Parameters Failed @ %s', ...
                                 datestr(now));
        return;
    end
    % Judge sigI Flag
    S = Price(end-299:end);
    bhF_L = buyHold(S);
    bhF_M = buyHold(S(end-199:end));
    bhF_S = buyHold(S(end-99:end));
    % Just for test in chart
%     LongOP = -LongLot;
%     ShortOP = -ShortLot;
    %---------------------------------------------------------------------------
    %                             Reverse Trend
    %---------------------------------------------------------------------------
    % deep reverse up to down, open short position
    if ((bhF_L == 3) && (bhF_M == 3)) || ((bhF_L == 3) && (bhF_S == 3)) || ...
       ((bhF_M == 3) && (bhF_S == 3))
        macdF = judgeMACD(S);
        impsF = judgeImpulse(S);
        if (macdF < 0) && (impsF < 0)
            if max(S) - S(end) <= 5
                LongOP = -LongLot;
                if (ShortLot + LotPerTrd) <= MaxTotalLot
                    ShortOP = LotPerTrd;        
                end
                Ops = [LongOP,ShortOP];
                return;
            end
        end
    % deep reverse down to up, open long position
    elseif ((bhF_L == -3) && (bhF_M == -3)) || ((bhF_L == -3) && (bhF_S == -3)) || ...
           ((bhF_M == -3) && (bhF_S == -3))
        macdF = judgeMACD(S);
        impsF = judgeImpulse(S);
        if (macdF > 0) && (impsF > 0)
            if S(end) - min(S) <= 5
                ShortOP = -ShortLot;
                if (LongLot + LotPerTrd) <= MaxTotalLot
                    LongOP = LotPerTrd;        
                end
                Ops = [LongOP,ShortOP];
                return;
            end
        end
    end
    %---------------------------------------------------------------------------
    %                             Follow Trend
    %--------------------------------------------------------------------------- 
    if (bhF_L > 0) && (bhF_M > 0) && ((bhF_S == 1) || (bhF_S == 2))
        macdF = judgeMACD(S);
        impsF = judgeImpulse(S);
        if ((macdF == 1) || (macdF == 2)) && ((impsF == 1) || (impsF == 2)) 
            ShortOP = -ShortLot;
            if (LongLot + LotPerTrd) <= MaxTotalLot
                LongOP = LotPerTrd;        
            end
            Ops = [LongOP,ShortOP];
            return;
        end
    elseif (bhF_L < 0) && (bhF_M < 0) && ((bhF_S == -1) || (bhF_S == -2))
        macdF = judgeMACD(S);
        impsF = judgeImpulse(S);
        if ((macdF == -1) || (macdF == -2)) && ((impsF == -1) || (impsF == -2))
            LongOP = -LongLot;
            if (ShortLot + LotPerTrd) <= MaxTotalLot
                ShortOP = LotPerTrd;        
            end
            Ops = [LongOP,ShortOP];
            return;
        end
    end
    %---------------------------------------------------------------------------
    %                              No Trend
    %---------------------------------------------------------------------------
    if (bhF_S == 0) && (bhF_M == 0) && (bhF_L == 0)
        [~,sigF] = judgeSig(S);
        if (sigF > 0)
            macdF = judgeMACD(S);
            if (macdF == 1) && (macdF == 2)
                impsF = judgeImpulse(S);
                if (impsF == 1) && (macdF == 2)
                    ShortOP = -ShortLot;
                    if (LongLot + LotPerTrd) <= MaxTotalLot
                        LongOP = LotPerTrd;        
                    end
                    Ops = [LongOP,ShortOP];
                    return;
                end
            end
        elseif (sigF < 0)
            macdF = judgeMACD(S);
            if (macdF == -1) || (macdF == -2)
                impsF = judgeImpulse(S);
                if (impsF == -1) || (impsF == -2)
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
    %---------------------------------------------------------------------------
    % returen operations
    %---------------------------------------------------------------------------
    Ops = [LongOP,ShortOP];
    %---------------------------------------------------------------------------
    % Record Operations in log file and mail to Paddy
    %---------------------------------------------------------------------------
%     if LongOP > 0
%         tmS = datestr(now);
%         g_Sparrow_Log.printInfo('Open Long Position %d Lot @ %s', ...
%                                 LongOP,tmS);
%         msg = sprintf('The sparrow strategy open %d lot long position at %s.\n\n%s', ...
%                       LongOP,tmS,g_Sparrow_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Sparrow Open Long Position',msg);
%     elseif LongOP < 0 
%         tmS = datestr(now);
%         g_Sparrow_Log.printInfo('Close Long Position %d Lot @ %s', ...
%                                 -LongOP,tmS);
%         msg = sprintf('The sparrow strategy close %d lot long position at %s.\n\n%s', ...
%                       -LongOP,tmS,g_Sparrow_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Sparrow Close Long Position',msg);
%     end
%     if ShortOP > 0
%         tmS = datestr(now);
%         g_Sparrow_Log.printInfo('Open Short Position %d Lot @ %s', ...
%                                 ShortOP,datestr(now));
%         msg = sprintf('The sparrow strategy open %d lot short position at %s.\n\n%s', ...
%                       ShortOP,tmS,g_Sparrow_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Sparrow Open Short Position',msg);
%     elseif ShortOP < 0
%         tmS = datestr(now);
%         g_Sparrow_Log.printInfo('Close Short Position %d Lot @ %s', ...
%                                 -ShortOP,tmS);
%         msg = sprintf('The sparrow strategy close %d lot short position at %s.\n\n%s', ...
%                       -ShortOP,tmS,g_Sparrow_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Sparrow Close Short Position',msg);
%     end
end