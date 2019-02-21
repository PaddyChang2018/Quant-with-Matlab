function alignTime(obj,reftime)
    % align m_BarSet time
    for i = 1 : length(obj.m_BarSet)
        bs = obj.m_BarSet(i);
        % first search
        delta = find(bs.Time(bs.Iterator:end) > reftime, 1) - 1; 
        if ~isempty(delta)
            % first search success
            bs.Iterator = bs.Iterator + delta - 1;
        else
            % second search
            delta = find(bs.Time(bs.Iterator:end) == reftime, 1);
            if ~isempty(delta)
                % second search success
                bs.Iterator = bs.Iterator + delta - 1;
            else
                obj.m_Log.printCrucial('Warning! %s %s bar series can not align time %s.', ...
                                       bs.InstID,char(bs.TimeFrame),datestr(reftime));
            end
        end
    end
    % align m_TickSet time
    for i = 1 : length(obj.m_TickSet)
        bs = obj.m_TickSet(i);
        % first search
        delta = find(bs.Time(bs.Iterator:end) > reftime, 1) - 1; 
        if ~isempty(delta)
            % first search success
            bs.Iterator = bs.Iterator + delta - 1;
        else
            % second search
            delta = find(bs.Time(bs.Iterator:end) == reftime, 1);
            if ~isempty(delta)
                % second search success
                bs.Iterator = bs.Iterator + delta - 1;
            else
                obj.m_Log.printCrucial('Warning! %s %s series can not align time %s.', ...
                                       bs.InstID,char(bs.TimeFrame),datestr(reftime));
            end
        end
    end
end