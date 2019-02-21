function recordCapital(obj,timeType,timeNum)
    if timeType == EnumType.DAY 
        if hour(timeNum) == 15
            capi = struct('time',timeNum,'capital',obj.m_Capital.clone);
            obj.m_CapiDayBox = [obj.m_CapiDayBox;capi];
        end
    elseif timeType == EnumType.HOUR
        if minute(timeNum) == 0
            capi = struct('time',timeNum,'capital',obj.m_Capital.clone);
            obj.m_CapiHourBox = [obj.m_CapiHourBox;capi];
        end
    else
        obj.m_Log.printCrucial('recordCapital() can not support time type:%s!',char(timeType));
    end   
end