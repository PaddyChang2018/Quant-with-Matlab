function price = getLastPrice(obj,instID)
    price = -1;
    if obj.m_DrvType == EnumType.TICK
        for i = 1 : length(obj.m_TickSet)
            if strcmp(obj.m_TickSet(i).InstID,instID)
                price = obj.m_TickSet(i).LastPrice(obj.m_TickSet(i).Iterator);
                return;
            end
        end
    else
        for i = 1 : length(obj.m_BarSet)
            if strcmp(obj.m_BarSet(i).InstID,instID)
                price = obj.m_BarSet(i).Close(obj.m_BarSet(i).Iterator);
                return;
            end
        end
    end
end