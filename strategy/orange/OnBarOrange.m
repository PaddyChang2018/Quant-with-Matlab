function OnBarOrange(sim,bar)
    m_M15 = sim.getFieldSeries('m1701',EnumType.M15,EnumType.CLOSE,100);
    a_M15 = sim.getFieldSeries('a1701',EnumType.M15,EnumType.CLOSE,100);
    y_M15 = sim.getFieldSeries('y1701',EnumType.M15,EnumType.CLOSE,100);
    m_M5 = sim.getFieldSeries('m1701',EnumType.M5,EnumType.CLOSE,140);
    a_M5 = sim.getFieldSeries('a1701',EnumType.M5,EnumType.CLOSE,140);
    y_M5 = sim.getFieldSeries('y1701',EnumType.M5,EnumType.CLOSE,140);
    % set trade insturment
    trdID = sim.m_TrdBS(1).InstID;
    trdflag = orange(m_M15,a_M15,y_M15,m_M5,a_M5,y_M5, ...
                     bar.Close);
    longPosi = sim.m_TrdSeat.getPosition(trdID,EnumType.BUY);
    shortPosi = sim.m_TrdSeat.getPosition(trdID,EnumType.SELL);
    if isa(longPosi,'FuturePosition')
        % update take profit price
        if bar.Close - longPosi.avgPrice >= 6
            newtp = longPosi.avgPrice + (bar.Close - longPosi.avgPrice)/2;
            if newtp > longPosi.tpPrice
                longPosi.tpPrice = newtp;
                longPosi.tpLot = longPosi.allowCloseLot; 
            end
        end
        % close long position
        if (trdflag(1) == 0 && longPosi.profit > 0) 
            sim.m_TrdSeat.closePosition(trdID,EnumType.SELL,bar.Close - 1, ...
                                        longPosi.allowCloseLot,bar.Time,EnumType.FAK);
        end
    end
    %
    if isa(shortPosi,'FuturePosition')
        % update take profit price
        if shortPosi.avgPrice - bar.Close >= 6
            newtp = shortPosi.avgPrice - (shortPosi.avgPrice - bar.Close)/2;
            if newtp < shortPosi.tpPrice
                shortPosi.tpPrice = newtp;
                shortPosi.tpLot = shortPosi.allowCloseLot;
            end
        end
        % close short position
        if (trdflag(2) == 0 && shortPosi.profit > 0)
            sim.m_TrdSeat.closePosition(trdID,EnumType.BUY,bar.Close + 1, ...
                                        shortPosi.allowCloseLot,bar.Time,EnumType.FAK);
        end
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