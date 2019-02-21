function tick = getLastTick(obj,instID)
    for i = 1 : length(obj.m_TickSet)
        if strcmp(obj.m_TickSet(i).InstID,instID)
            ts = obj.m_TickSet(i);
            itor = obj.m_TickSet(i).Iterator;
            tick = Tick(obj.m_Log,instID,ts.Time(itor),ts.MilliSecond(itor), ...
                        ts.LastPrice(itor),ts.AskPrice1(itor),ts.AskVolume1(itor), ...
                        ts.BidPrice1(itor),ts.BidVolume1(itor));
            return;
        end
    end
end