%-----------------------------------------------------------------------------
% bs is a BarSeries object
%-----------------------------------------------------------------------------
function judgeTrend(obj,bs)
    %---------------------init judge condition flag---------------------------
    updown = 0;
    force = 0;
    upEnd = 0;
    downEnd = 0;  
    %--------------------------middle varaibles-------------------------------
    % red or green
    rg = bs.Close(end-2:end) - bs.Open(end-2:end);
    % long/short ratio
    ls = (bs.Close(end-2:end) - bs.Low(end-2:end)) ./ (bs.High(end-2:end) - bs.Close(end-2:end));
    % entity abs(open - close)
    oc = abs(bs.Open(end-2:end) - bs.Close(end-2:end));
    % high - low
    hl = bs.High(end-2:end) - bs.Low(end-2:end);
    % close avgerage  
    avgC = zeros(length(bs.Close),1);
    avgC(1) = bs.Close(1);
    for i = 2:length(bs.Close)
        avgC(i) = avgC(i) * 0.4 + bs.Close(i) * 0.6;
    end
    %------------------------------------------------------------------------
    % judge updown flag(single,universal)
    %------------------------------------------------------------------------
    % judge up trend
    if avgC(end) > (avgC(end-1) + 3)
        updown = updown + 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u30');
        end
    end
    if (rg(end) > 0) && (rg(end-1) > 0) && (rg(end-2) > 0)
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u33');
        end
        updown = updown + 1;
    end
    if (bs.Low(end) > bs.Low(end-1)) && (bs.Low(end-1) > bs.Low(end-2)) 
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u37');
        end
        updown = updown + 1;
    end
    if (bs.Open(end) > bs.Open(end-1)) && (bs.Open(end-1) > bs.Open(end-2))
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u41');
        end
        updown = updown + 1;
    end
    if (bs.High(end) > bs.High(end-1)) && (bs.High(end-1) > bs.High(end-2))
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u45');
        end
        updown = updown + 1;
    end
    if (bs.Close(end) > bs.Close(end-1)) && (bs.Close(end-1) > bs.Close(end-2))
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u49');
        end
        updown = updown + 1;
    end 
    if (ls(end) >= 2) && (ls(end-1) >= 2) && (ls(end-2) >1)
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u53');
        end
        updown = updown + 1;
    elseif (ls(end) >= 2) && (ls(end-1) > 1) && (ls(end-2) >= 2)
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u56');
        end
        updown = updown + 1;
    elseif (ls(end) >= 1.5) && (ls(end-1) >= 2) && (ls(end-2) >= 2)
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u59');
        end
        updown = updown + 1;
    end
    % judge down trend
    if avgC(end) < (avgC(end-1) - 3)
        updown = updown - 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u65');
        end
    end
    if (rg(end) < 0) && (rg(end-1) < 0) && (rg(end-2) < 0)
        updown = updown - 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u69');
        end
    end
    if (bs.Low(end) < bs.Low(end-1)) && (bs.Low(end-1) < bs.Low(end-2)) 
        updown = updown - 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u73');
        end
    end
    if (bs.Open(end) < bs.Open(end-1)) && (bs.Open(end-1) < bs.Open(end-2))
        updown = updown - 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u77');
        end
    end
    if (bs.High(end) < bs.High(end-1)) && (bs.High(end-1) < bs.High(end-2))
        updown = updown - 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u81');
        end
    end
    if (bs.Close(end) < bs.Close(end-1)) && (bs.Close(end-1) < bs.Close(end-2))
        updown = updown - 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u85');
        end
    end
    if (ls(end) <= 0.5) && (ls(end-1) <= 0.5) && (ls(end-2) < 1)
        updown = updown - 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u89');
        end
    elseif (ls(end) <= 0.5) && (ls(end-1) < 1) && (ls(end-2) <= 0.5)
        updown = updown - 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u92');
        end
    elseif (ls(end) <= 0.7) && (ls(end-1) <= 0.5) && (ls(end-2) <= 0.5)
        updown = updown - 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('u95');
        end
    end
    %------------------------------------------------------------------------
    % judge reverse factors RSI to updown 
    %------------------------------------------------------------------------
    r = rsindex(bs.Close,7);
    if obj.m_TrendInfo.TrendFlag == EnumType.UP
        if max(r(end-2:end)) > 80
            if (updown < 0) || (bs.Low(end) == min(bs.Low(end-2:end)))
                updown = updown - 1;
                if obj.m_Debug == EnumType.ON
                    obj.m_Log.printInfo('u105');
                end
                if ((r(end-1) > r(end)) && (r(end-1) > r(end-2))) || ...
                   (r(end) < r(end-1)) && (r(end-1) < r(end-2))    
                    updown = updown - 1;
                    if obj.m_Debug == EnumType.ON
                        obj.m_Log.printInfo('u109');
                    end
                end
            end
        end
    elseif obj.m_TrendInfo.TrendFlag == EnumType.DOWN
        if min(r(end-2:end)) < 20
            if (updown > 0) || (bs.High(end) == max(bs.High(end-2:end)))
                updown = updown + 1;
                if obj.m_Debug == EnumType.ON
                    obj.m_Log.printInfo('u117');
                end
                if ((r(end) > r(end-1)) && (r(end-1) < r(end - 2))) || ...
                   ((r(end) > r(end-1)) && (r(end-1) > r(end -2)))
                    updown = updown + 1;
                    if obj.m_Debug == EnumType.ON
                        obj.m_Log.printInfo('u121');
                    end
                end
            end
        end
    else
        if min(r(end-2:end)) < 20
            if updown > 0
                updown = updown + 1;
                if obj.m_Debug == EnumType.ON
                    obj.m_Log.printInfo('u129');
                end
            end
        end
        if max(r(end-2:end)) > 80
            if updown < 0
                updown = updown - 1;
                if obj.m_Debug == EnumType.ON
                    obj.m_Log.printInfo('u135');
                end
            end
        end
    end
    %--------------------------------------------------------------------------
    % juduge force flag(single,universal)
    %--------------------------------------------------------------------------
    if oc(end) >= 4 && abs(bs.Close(end) - bs.Open(end-2)) >= 8
        force = force + 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('f144');
        end
    end
    if ((oc(end) > oc(end-1) * 2) || (oc(end) > oc(end-2)*2)) && ...
       (oc(end) >= 5)
        force = force + 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('f149');
        end
    end
    if (oc(end) > oc(end-1)) && (oc(end-1) > oc(end-2)) && (oc(end) >= 5)
        force = force + 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('f153');
        end
    end
    %--------------------------------------------------------------------------
    % judge updown and force flag at the same time
    % up to down 
    if (rg(end-2) >= 0) && (rg(end-1) <= 0) &&(rg(end) < 0)
        if (oc(end) + oc(end-1) > hl(end-2)) && (oc(end) > oc(end-1)) && ...
           (bs.Close(end) <= min(bs.Low(end-2:end-1)))
            updown = updown - 1;
            force = force + 1;
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('fu163');
            end
            if max(r(end-2:end)) >= 80
                force = force + 1;
                if obj.m_Debug == EnumType.ON
                    obj.m_Log.printInfo('f166');
                end
            end
        end 
    end
    if (rg(end-2) >= 0) && (rg(end-1) >= 0) &&(rg(end) < 0)
        if (oc(end) > hl(end-1) + hl(end-2)) && (oc(end) >= 4) && ...
           (bs.Close(end) <= min(bs.Low(end-2:end-1)))
            updown = updown - 1;
            force = force + 1;
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('fu175');
            end
            if max(r(end-2:end)) >= 80
                force = force + 1;
                if obj.m_Debug == EnumType.ON
                    obj.m_Log.printInfo('f178');
                end
            end
        end
    end
    % down to up
    if (rg(end-2) <= 0) && (rg(end-1) >= 0) && (rg(end) > 0)
        if (oc(end) + oc(end-1) > hl(end-2)) && (oc(end) > oc(end-1)) && ...
           (bs.Close(end) >= max(bs.High(end-2:end-1)))
            updown = updown + 1;
            force = force + 1;
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('fu188');
            end
            if min(r(end-2:end)) <= 20
                force = force + 1;
                if obj.m_Debug == EnumType.ON
                    obj.m_Log.printInfo('f191');
                end
            end
        end
    end
    if (rg(end-2) <= 0) && (rg(end-1) <= 0) && (rg(end) > 0)
        if (oc(end) > hl(end-1) + hl(end-2)) && (oc(end) >= 4) && ...
           (bs.Close(end) >= max(bs.High(end-2:end-1)))
            updown = updown + 1;
            force = force + 1;
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('fu200');
            end
            if min(r(end-2:end)) <= 20
                force = force + 1;
                if obj.m_Debug == EnumType.ON
                    obj.m_Log.printInfo('f203');
                end
            end
        end
    end
    %--------------------------------------------------------------------------
    % judge upEnd&downEnd flag,use max draw down indicator
    % update trend high and low price
    if obj.m_TrendInfo.LowPrice > min(bs.Low(end-2:end))
        obj.m_TrendInfo.LowPrice = min(bs.Low(end-2:end));
    end
    if obj.m_TrendInfo.HighPrice < max(bs.High(end-2:end))
        obj.m_TrendInfo.HighPrice = max(bs.High(end-2:end));
    end
    if obj.m_TrendInfo.TrendFlag == EnumType.UP
       dd = (obj.m_TrendInfo.HighPrice - bs.Close(end))/(obj.m_TrendInfo.HighPrice - obj.m_TrendInfo.LowPrice);
       if (dd > 0.3) && ((obj.m_TrendInfo.HighPrice - bs.Close(end)) >= 5) && ...
          (updown < 0) && (bs.High(end) ~= obj.m_TrendInfo.HighPrice)
           upEnd = 1;
       end
    elseif obj.m_TrendInfo.TrendFlag == EnumType.DOWN
       dd = (bs.Close(end) - obj.m_TrendInfo.LowPrice)/(obj.m_TrendInfo.HighPrice - obj.m_TrendInfo.LowPrice);
       if (dd > 0.3) && ((bs.Close(end) - obj.m_TrendInfo.LowPrice) >= 5) && ...
          (updown > 0) && (bs.Low(end) ~= obj.m_TrendInfo.LowPrice)
           downEnd = 1;
       end
    end
    if (abs(updown) >= 4) && (force == 0)
        if oc(end) > oc(end-1) && oc(end) > oc(end-2)
            force = force + 1;
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('f232');
            end
        end
    end
    %------------------------------------------------------------------------
    % update trend info
    %------------------------------------------------------------------------
    if obj.m_Debug == EnumType.ON
        obj.m_Log.printInfo('%s updown=%d force=%d upEnd=%d downEnd=%d', ...
                   datestr(bs.Time(end)),updown,force,upEnd,downEnd);
    end
    if obj.m_TrendInfo.TrendFlag == EnumType.UP
        % up trend end 
        if ((updown <= -1) && (force >= 1)) || (upEnd >= 1) 
            obj.m_TrendInfo.TrendFlag = EnumType.NONE;
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('UP   Trend End %s Bar:%d %d %d %d\n', ...
                           datestr(bs.Time(end)), ...
                           bs.Open(end),bs.High(end),bs.Low(end),bs.Close(end));
            end
        end
        % revert trend up to down
        if (updown <= -2) && (force >= 1)
            obj.m_TrendInfo.TrendFlag = EnumType.DOWN;
            [ma,i] = max(bs.High(end-2:end));
            obj.m_TrendInfo.HighPrice = ma;
            [mi,j] = min(bs.Low(end-2:end));
            if j >= i
                obj.m_TrendInfo.LowPrice = mi;
            else
                obj.m_TrendInfo.LowPrice = min(bs.Low(i:end));
            end
            obj.m_TrendInfo.StartTime = bs.Time(end-3+i);
            obj.m_TrendInfo.EndTime = bs.Time(end);
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('Down Trend Start:%s High=%d Low=%d Now:%s Bar:%d %d %d %d\n', ...
                            datestr(obj.m_TrendInfo.StartTime), ...
                            obj.m_TrendInfo.HighPrice, ...
                            obj.m_TrendInfo.LowPrice, ...
                            datestr(bs.Time(end)), ...
                            bs.Open(end),bs.High(end),bs.Low(end),bs.Close(end));
            end
        else % continue trend
            ma = max(bs.High(end-2:end));
            if  ma > obj.m_TrendInfo.HighPrice
                obj.m_TrendInfo.HighPrice = ma;
            end
            mi = min(bs.Low(end-2:end));
            if mi < obj.m_TrendInfo.LowPrice
                obj.m_TrendInfo.LowPrice = mi;
            end
            obj.m_TrendInfo.EndTime = bs.Time(end);
        end
    elseif obj.m_TrendInfo.TrendFlag == EnumType.DOWN
        % down trend end
        if ((updown >= 1) && (force >= 1)) || (downEnd >= 1)
            obj.m_TrendInfo.TrendFlag = EnumType.NONE;
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('Down Trend End:%s Bar:%d %d %d %d\n', ...
                            datestr(bs.Time(end)), ...
                            bs.Open(end),bs.High(end),bs.Low(end),bs.Close(end));
            end
        end
        % revert trend down to up
        if (updown >= 2) && (force >= 1)
            obj.m_TrendInfo.TrendFlag = EnumType.UP;
            [mi,i] = min(bs.Low(end-2:end));
            obj.m_TrendInfo.LowPrice = mi;
            [ma,j] = max(bs.High(end-2:end));
            if j >= i
                obj.m_TrendInfo.HighPrice = ma;
            else
                obj.m_TrendInfo.HighPrice = max(bs.High(i:end));
            end
            obj.m_TrendInfo.StartTime = bs.Time(end-3+i);
            obj.m_TrendInfo.EndTime = bs.Time(end);
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('Up   Trend Start:%s High=%d Low=%d Now:%s Bar:%d %d %d %d\n', ...
                            datestr(obj.m_TrendInfo.StartTime), ...
                            obj.m_TrendInfo.HighPrice, ...
                            obj.m_TrendInfo.LowPrice, ...
                            datestr(bs.Time(end)), ...
                            bs.Open(end),bs.High(end),bs.Low(end),bs.Close(end));
            end
        else % continue trend
            mi = min(bs.Low(end-2:end));
            if mi < obj.m_TrendInfo.LowPrice
                obj.m_TrendInfo.LowPrice = mi;
            end
            ma = max(bs.High(end-2:end));
            if ma > obj.m_TrendInfo.HighPrice
                obj.m_TrendInfo.HighPrice = ma;
            end
            obj.m_TrendInfo.EndTime = bs.Time(end);
        end
    else
        if (updown >= 2) && (force >= 1)  % new up trend
            obj.m_TrendInfo.TrendFlag = EnumType.UP;
            [mi,i] = min(bs.Low(end-2:end));
            obj.m_TrendInfo.LowPrice = mi;
            [ma,j] = max(bs.High(end-2:end));
            if j >= i
                obj.m_TrendInfo.HighPrice = ma;
            else
                obj.m_TrendInfo.HighPrice = max(bs.High(i:end));
            end
            obj.m_TrendInfo.StartTime = bs.Time(end-3+i);
            obj.m_TrendInfo.EndTime = bs.Time(end);
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('Up   Trend Start:%s High=%d Low=%d Now:%s Bar:%d %d %d %d\n', ...
                            datestr(obj.m_TrendInfo.StartTime), ...
                            obj.m_TrendInfo.HighPrice, ...
                            obj.m_TrendInfo.LowPrice, ...
                            datestr(bs.Time(end)), ...
                            bs.Open(end),bs.High(end),bs.Low(end),bs.Close(end));
            end
        elseif (updown <= -2) && (force >= 1)  % new down trend
            obj.m_TrendInfo.TrendFlag = EnumType.DOWN;
            [ma,i] = max(bs.High(end-2:end));
            obj.m_TrendInfo.HighPrice = ma;
            [mi,j] = min(bs.Low(end-2:end));
            if j >= i
                obj.m_TrendInfo.LowPrice = mi;
            else
                obj.m_TrendInfo.LowPrice = min(bs.Low(i:end));
            end
            obj.m_TrendInfo.StartTime = bs.Time(end-3+i);
            obj.m_TrendInfo.EndTime = bs.Time(end);
            if obj.m_Debug == EnumType.ON
                obj.m_Log.printInfo('Down Trend Start:%s High=%d Low=%d Now:%s Bar:%d %d %d %d\n', ...
                            datestr(obj.m_TrendInfo.StartTime), ...
                            obj.m_TrendInfo.HighPrice, ...
                            obj.m_TrendInfo.LowPrice, ...
                            datestr(bs.Time(end)), ...
                            bs.Open(end),bs.High(end),bs.Low(end),bs.Close(end));
            end
        end
    end
end