function sendOrder(obj,instID,openclose,buysell,price,lot,expire)
    enOrder = FutureOrder(instID,openclose,buysell,price,lot, ...
                          now,1,expire);
    if ~isempty(obj.m_EntrustBox)
        obj.m_EntrustBox = [obj.m_EntrustBox;enOrder];
    else
        obj.m_EntrustBox = enOrder;
    end
end



