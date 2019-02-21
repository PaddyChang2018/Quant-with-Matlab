function cancelOrder(obj,ordID)
    i = 1;
    while i <= length(obj.m_EntrustBox)
        
        if obj.m_EntrustBox(i).id == ordID
            obj.m_EntrustBox(i).delete;
            obj.m_EntrustBox = [obj.m_EntrustBox(1:i-1);obj.m_EntrustBox(i+1:end)];
            i = i - 1;
        end
        i = i + 1;
    end
end