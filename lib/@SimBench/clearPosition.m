function clearPosition(obj,time)
    pb = obj.m_TrdSeat.getPosition;
    for i = 1 : length(pb);
        if isvalid(pb(i))
            % find close position price
            price = obj.getLastPrice(pb(i).instID);
            if pb(i).buysell == EnumType.BUY
                bysl = EnumType.SELL;
            elseif pb(i).buysell == EnumType.SELL
                bysl = EnumType.BUY;
            else
                obj.m_Log.printCrucial('Error! %s position buysell type(%s) is error.', ...
                                       pb(i).instID,char(pb(i).buysell));
            end
            % call close position function
            if nargin == 1
                obj.m_TrdSeat.closePosition(pb(i).instID,bysl,price,pb(i).allowCloseLot, ...
                                            obj.m_RefClock,EnumType.FAK);
            elseif nargin == 2
                obj.m_TrdSeat.closePosition(pb(i).instID,bysl,price,pb(i).allowCloseLot, ...
                                            time,EnumType.FAK);
            else
                obj.m_Log.printFatal('Error! SimBench.clearPosition() only accept 0/1 input arguments.');
            end
        end
    end
end