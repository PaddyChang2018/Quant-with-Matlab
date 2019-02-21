function OnBarAMY(sim,bar)
    global g_TP;
    hh = hour(bar.Time);
    mm = minute(bar.Time);
    if (hh > 15) || (hh < 9) || ((hh == 9)&&(mm < 5))
        return;
    end
    % get bar series object
    a5 = sim.getBSTblVal('a1701',EnumType.M5,31);
    m5 = sim.getBSTblVal('m1701',EnumType.M5,31);
    y5 = sim.getBSTblVal('y1701',EnumType.M5,31);
    flag = AMY(a5.Close,m5.Close,y5.Close); 
    %---------------------------------------------------------------------------
    % flag = [opncls,pair,Ldir];
    %---------------------------------------------------------------------------
    if flag(1) == 0
        % clear position
        sim.clearPosition;
    elseif flag(1) == 2
        % close old arbitrage and open new arbitrage
        sim.clearPosition;
        % after 14:50 do not permit open position
        if (hh == 14) && (mm > 50)
            return;
        end
        % open arbitrage
        Li = floor(flag(2)/10);
        Ri = mod(flag(2),10);
        instL = sim.m_TrdBS(Li).InstID;
        instR = sim.m_TrdBS(Ri).InstID;
        prcL = sim.getLastPrice(instL);
        prcR = sim.getLastPrice(instR);
        if flag(3) == 1
            sim.m_TrdSeat.openPosition(instL,EnumType.BUY,prcL+1,1,bar.Time);
            sim.m_TrdSeat.openPosition(instR,EnumType.SELL,prcR-1,1,bar.Time);
        elseif flag(3) == -1
            sim.m_TrdSeat.openPosition(instL,EnumType.SELL,prcL-1,1,bar.Time);
            sim.m_TrdSeat.openPosition(instR,EnumType.BUY,prcR+1,1,bar.Time);
        else
            sim.m_Log.printCrucial('Error! Arbitrage direction(%d) is error.', flag(3));
        end
        % reset take profit
        g_TP = 0;
    elseif flag(1) == 1
        % after 14:50 do not permit open position
        if (hh == 14) && (mm > 50)
            return;
        end
        % open new arbitrage
        Li = floor(flag(2)/10);
        Ri = mod(flag(2),10);
        instL = sim.m_TrdBS(Li).InstID;
        instR = sim.m_TrdBS(Ri).InstID;
        prcL = sim.getLastPrice(instL);
        prcR = sim.getLastPrice(instR);
        if flag(3) == 1
            sim.m_TrdSeat.openPosition(instL,EnumType.BUY,prcL+1,1,bar.Time);
            sim.m_TrdSeat.openPosition(instR,EnumType.SELL,prcR-1,1,bar.Time);
        elseif flag(3) == -1
            sim.m_TrdSeat.openPosition(instL,EnumType.SELL,prcL-1,1,bar.Time);
            sim.m_TrdSeat.openPosition(instR,EnumType.BUY,prcR+1,1,bar.Time);
        else
            sim.m_Log.printCrucial('Error! Arbitrage direction(%d) is error.', flag(3));
        end
        % reset take profit
        g_TP = 0;
    end
    %
    gain = sim.m_TrdSeat.getPosiGain;
    if gain ~= -Inf
        % stop loss
        if gain <= -100 
            sim.clearPosition;
            resetState;
        end
        % take profit 
        if (gain >= 100) && (g_TP < gain * 0.8)
            g_TP = gain * 0.8;
        end
        if (g_TP ~= 0) && (gain <= g_TP)
            sim.clearPosition;
            resetState;
        end
    end 
end