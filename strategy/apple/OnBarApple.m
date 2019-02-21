function OnBarApple(sim,bar)
    hh = hour(bar.Time);
    mm = minute(bar.Time);
    if (hh > 15) || (hh < 9) || ((hh == 9)&&(mm < 20)) || ...
       ((hh == 14) && (mm > 50))
        return;
    end
    % get bar series object
    bs = sim.getBarSeries('m1701',EnumType.M1,20);
    % set trade insturment
    trdID = sim.m_TrdBS(1).InstID;
    trdflag = apple(bs.Open,bs.High,bs.Low,bs.Close);
    % delete bar series object
    bs.delete;
    longPosi = sim.m_TrdSeat.getPosition(trdID,EnumType.BUY);
    shortPosi = sim.m_TrdSeat.getPosition(trdID,EnumType.SELL);
    if isa(longPosi,'FuturePosition')
        % update take profit price
        if bar.High - longPosi.avgPrice >= 10
            newtp = round(longPosi.avgPrice + (bar.High - longPosi.avgPrice)*0.6);
            if newtp > longPosi.tpPrice
                longPosi.tpPrice = newtp;
                longPosi.tpLot = longPosi.allowCloseLot; 
            end
        end
        % close long position
        if trdflag(1) == 0
            sim.m_TrdSeat.closePosition(trdID,EnumType.SELL,bar.Close - 1, ...
                                        longPosi.allowCloseLot,bar.Time,EnumType.FAK);
        end
    end
    %
    if isa(shortPosi,'FuturePosition')
        % update take profit price
        if shortPosi.avgPrice - bar.Low >= 10
            newtp = round(shortPosi.avgPrice - (shortPosi.avgPrice - bar.Low)*0.6);
            if shortPosi.tpPrice ~= 0
                if newtp < shortPosi.tpPrice
                    shortPosi.tpPrice = newtp;
                    shortPosi.tpLot = shortPosi.allowCloseLot;
                end
            else
                shortPosi.tpPrice = newtp;
                shortPosi.tpLot = shortPosi.allowCloseLot;
            end
        end
        % close short position
        if trdflag(2) == 0 
            sim.m_TrdSeat.closePosition(trdID,EnumType.BUY,bar.Close + 1, ...
                                        shortPosi.allowCloseLot,bar.Time,EnumType.FAK);
        end
    end
    % after 14:50 do not permit open position
    if (hh == 14) && (mm > 50)
        return;
    end
    % open long position
    if (trdflag(1) == 1) 
        flag = sim.m_TrdSeat.openPosition(trdID,EnumType.BUY,bar.Close+1,1,bar.Time);
        if flag == 1
            longPosi = sim.m_TrdSeat.getPosition(trdID,EnumType.BUY);
            longPosi.slPrice = bar.Close - 9;
            longPosi.slLot = longPosi.allowCloseLot;
        end
    end
    % open short position
    if trdflag(2) == 1
        flag = sim.m_TrdSeat.openPosition(trdID,EnumType.SELL,bar.Close-1,1,bar.Time);
        if flag == 1
            shortPosi = sim.m_TrdSeat.getPosition(trdID,EnumType.SELL);
            shortPosi.slPrice = bar.Close + 9;
            shortPosi.slLot = shortPosi.allowCloseLot;
        end
    end
end