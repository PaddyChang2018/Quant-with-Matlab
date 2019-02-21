function bar = getLastBar(obj,instID,timetype,freq)
    if timetype == EnumType.MINUTE
        for i = 1 : length(obj.m_BarSet)
            if strcmp(obj.m_BarSet(i).InstID,instID) && ...
                     (obj.m_BarSet(i).TimeFrame == EnumType.M1)
                bs = obj.m_BarSet(i);
                itor = obj.m_BarSet(i).Iterator - mod(obj.m_BarSet(i).Iterator,freq);
                
                bar = Bar(obj.m_Log,instID,bs.Time(itor),bs.Open(itor-freq+1), ...
                          max(bs.High(itor-freq+1:itor)),min(bs.Low(itor-freq+1:itor)), ...
                          bs.Close(itor),sum(bs.Volume(itor-freq+1:itor)), ...
                          sum(bs.Turnover(itor-freq+1:itor)));
                return;
            end
        end
    elseif timetype == EnumType.DAY
        for i = 1 : length(obj.m_BarSet)
            if strcmp(obj.m_BarSet(i).InstID,instID) && ...
                     (obj.m_BarSet(i).TimeFrame == EnumType.D1)
                bs = obj.m_BarSet(i);
                itor = obj.m_BarSet(i).Iterator;
                bar = Bar(obj.m_Log,instID,bs.Time(itor),bs.Open(itor), ...
                          bs.High(itor),bs.Low(itor),bs.Close(itor), ...
                          bs.Volume(itor),bs.Turnover(itor)); 
                return;
            end
        end
    else
        obj.m_Log.printCrucial('Error! getLastBar() can not recognize timetype %s.', ...
                               char(timetype));
    end
end