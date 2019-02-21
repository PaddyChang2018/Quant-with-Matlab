function OnTaskApple(sim,~)
    % close all position at task time 14:50
    pb = sim.m_TrdSeat.getPosition;
    for i = 1 : length(pb);
        if isvalid(pb(i))
            % find close position price
            bar = sim.getLastBar(pb(i).instID,EnumType.M1);
            if pb(i).buysell == EnumType.BUY
                bysl = EnumType.SELL;
                price = bar.Close - 1;
            elseif pb(i).buysell == EnumType.SELL
                bysl = EnumType.BUY;
                price = bar.Close + 1;
            else
                sim.m_Log.printCrucial('Error! %s position buysell type(%s) is error.', ...
                                       pb(i).instID,char(pb(i).buysell));
            end
            % call close position function
            sim.m_TrdSeat.closePosition(pb(i).instID,bysl,price,pb(i).allowCloseLot, ...
                                        bar.Time,EnumType.FAK);
        end
    end
end