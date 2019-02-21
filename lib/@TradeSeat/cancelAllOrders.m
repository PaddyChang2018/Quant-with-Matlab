function cancelAllOrders(obj)
    i = 1;
    while i<= length(obj.m_EntrustBox)
        obj.m_EntrustBox(i).delete;
        i = i + 1;
    end
    obj.m_EntrustBox = [];
end