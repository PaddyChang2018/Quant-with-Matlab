function Ops = dove(Price,LongLot,ShortLot,MaxTotalLot,LotPerTrd)
    global g_Dove_Valid;
    global g_Dove_Log;
%     global g_Dove_IP;
    % Initial return values
    LongOP = 0;
    ShortOP = 0;
    % Check License Valid
    if ~g_Dove_Valid
        if isvalid(g_Dove_Log)
            g_Dove_Log.printFatal('Error! Dove License Invalid @ %s', ...
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
        g_Dove_Log.printFatal('Error! Check Input Parameters Failed @ %s', ...
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
    % Test : Close Position after one bar
%     LongOP = -LongLot;
%     ShortOP = -ShortLot;
    %
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
            if (fast(end) > slow(end) + 2) && (S(end) > fast(end)) && (slow(end) > slow(end-5))
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
            if (fast(end) < slow(end) - 2) && (S(end) < fast(end)) && (slow(end) < slow(end-5))
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
    else
        % Judge sigI Flag
        S = Price(end-299:end);
        bhF_L = buyHold(S);
        bhF_M = buyHold(S(end-199:end));
        bhF_S = buyHold(S(end-99:end));
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
    end
    % return operation
    Ops = [LongOP,ShortOP];
    %---------------------------------------------------------------------------
    % Record Operations in log file and mail to Paddy
    %---------------------------------------------------------------------------
%     if LongOP > 0
%         tmS = datestr(now);
%         g_Dove_Log.printInfo('Open Long Position %d Lot @ %s', ...
%                              LongOP,tmS);
%         msg = sprintf('The dove strategy open %d lot long position at %s.\n\n%s', ...
%                       LongOP,tmS,g_Dove_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Dove Open Long Position',msg);
%     elseif LongOP < 0 
%         tmS = datestr(now);
%         g_Dove_Log.printInfo('Close Long Position %d Lot @ %s', ...
%                               -LongOP,tmS);
%         msg = sprintf('The dove strategy close %d lot long position at %s.\n\n%s', ...
%                       -LongOP,tmS,g_Dove_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Dove Close Long Position',msg);
%     end
%     if ShortOP > 0
%         tmS = datestr(now);
%         g_Dove_Log.printInfo('Open Short Position %d Lot @ %s', ...
%                              ShortOP,tmS);
%         msg = sprintf('The dove strategy open %d lot short position at %s.\n\n%s', ...
%                       ShortOP,tmS,g_Dove_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Dove Open Short Position',msg);
%     elseif ShortOP < 0
%         tmS = datestr(now);
%         g_Dove_Log.printInfo('Close Short Position %d Lot @ %s', ...
%                              -ShortOP,tmS);
%         msg = sprintf('The dove strategy close %d lot short position at %s.\n\n%s', ...
%                       -ShortOP,tmS,g_Dove_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Dove Close Short Position',msg);
%     end
end