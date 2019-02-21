function flag = startSimulate(obj,startDay,endDay)
    % trigger init event
    notify(obj,'e_SimInit');
    % set simulate period
    obj.m_StartTime = startTime;
    obj.m_EndTime = endTime;
    % load min and day data
    for i = 1 : length(obj.m_InstSet)
        dayfile = sprintf('%sdata\futureday\%s',obj.m_RootPath,obj.m_InstSet(i));
        DB = BarSeries(obj.m_InstSet(i),EnumType.D1,obj.m_Log,readtable(dayfile));
        obj.m_BarSet = [obj.m_BarSet;DB];
        minfile = sprintf('%sdata\futuremin\%s',obj.m_RootPath,obj.m_InstSet(i));
        MB = BarSeries(obj.m_InstSet(i),EnumType.M1,obj.m_Log,readtable(minfile));
        obj.m_BarSet = [obj.m_BarSet;MB];
        if strcmp(obj.m_InstSet(i),obj.m_DrvInst) && isvalid(MB)
            obj.m_DrvBar = MB;
        end
    end
    %
    if obj.m_DrvType == EnumType.TICK
        for i = startTime : days(1) : endTime
            % load tick data
            for j = 1 : length(obj.m_InstSet)
                tickfile = sprintf('%sdata\futuretick\%s\%s',obj.m_RootPath, ...
                                   datestr(i,'yyyymmdd'),obj.m_InstSet(j));
                TS = TickSeries(obj.m_InstSet(j),obj.m_Log,readtable(tickfile));
                obj.m_TickSet = [obj.m_TickSet;TS];
                if strcmp(obj.m_InstSet(j),obj.m_DrvInst)
                    obj.m_DrvTick = TS;
                end
            end
            for k = 1 : length(obj.m_DrvTick)
                % align time base on drive tick time
                obj.alignTime(obj.m_DrvTick.Time(k));
                % monitor entrust orders
                for n = 1 : length(obj.m_TickSet)
                    itor = obj.m_TickSet(n).Iterator; 
                    obj.m_TrdSeat.monitorOrder(obj.m_TickSet(n).Time(itor), ...
                                               obj.m_TickSet(n).InstID, ...
                                               obj.m_TickSet(n).LastPrice(itor));
                end
                tk =  Tick(obj.m_Log,obj.m_DrvTick.InstID,obj.m_DrvTick.Time(k), ...
                           obj.m_DrvTick.Millisecond(k),obj.m_DrvTick.Lastprice(k), ...
                           obj.m_DrvTick.Askprice1(k),obj.m_DrvTick.Askvolume1(k), ...
                           obj.m_DrvTick.Bidprice1(k),obj.m_DrvTick.Bidvolume1(k));
                % notify OnTick event
                notify(obj,'e_OnTick',tk);
                % delete tk object
                tk.delete;
                % update platform snapshot by time instrument and price
            end
            % record day capital and settlement
            obj.m_TrdSeat.recordCapital(EnumType.DAY,obj.m_DrvTick.Time(end));
            obj.m_TrdSeat.settlement;
        end
    elseif obj.m_DrvType == EnumType.MINUTE
        if isempty(obj.m_DrvBar) || (~isvalid(obj.m_DrvBar))
            obj.m_Log.printFatal('Error! startSimulate() drive bar is not ready.');
            flag = -1;
            notify(obj,'e_SimExit');
            return;
        end
        % confirm drive bar series start and end index
        obj.m_DrvStartIdx = find(obj.m_DrvBar.Time >= startDay,1);
        obj.m_DrvEndIdx = find(obj.m_DrvBar.Time == endDay + hours(15),1);
        if isempty(obj.m_DrvStartIdx)
            obj.m_Log.printFatal('Error! There is no trade data at start-time %s.', ...
                                 datestr(startTime));
            flag = -3;
            notify(obj,'e_SimExit');
            return;
        end
        if isempty(obj.m_DrvEndIdx)
            obj.m_Log.printFatal('Error! There is no trade data at end-time %s.', ...
                                 datestr(endTime));
            flag = -4;
            notify(obj,'e_SimExit');
            return;
        end
        if obj.m_DrvStartIdx >= obj.m_DrvEndIdx
            obj.m_Log.printFatal('Error! startSimulate() simulate period start-time should prior to end-time.');
            flag = -5;
            notify(obj,'e_SimExit');
            return;
        end
        for i = obj.m_DrvStartIdx : obj.m_DrvEndIdx
            % align time base on drive bar time
            obj.alignTime(obj.m_DrvBar.Time(i));
            % monitor position and entrust orders
            for j = 1 : length(obj.m_BarSet)
                if obj.m_BarSet(j).TimeFrame == EnumType.M1
                    itor = obj.m_BarSet(j).Iterator;
                    obj.m_TrdSeat.monitorOrder(obj.m_DrvBar.Time(i), ...
                                               obj.m_BarSet(j).InstID, ...
                                               obj.m_BarSet(j).High(itor), ...
                                               obj.m_BarSet(j).Low(itor));
                end
            end
            % fill bar object
            b = Bar(obj.m_Log,obj.m_DrvBar.InstID,obj.m_DrvBar.Time(i), ...
                    obj.m_DrvBar.Open(i),obj.m_DrvBar.High(i), ...
                    obj.m_DrvBar.Low(i),obj.m_DrvBar.Close(i), ...
                    obj.m_DrvBar.Volume(i),obj.m_DrvBar.Turnover(i));
            % notify OnBar event
            notify(obj,'e_OnBar',b);
            % delete bar object
            b.delete;
            % update platform snapshot by time instrument and price
            for k = 1 : length(obj.m_BarSet)
                if obj.m_BarSet(k).TimeFrame == EnumType.M1
                    obj.m_TrdSeat.snapshot(obj.m_BarSet(k).InstID, ...
                        obj.m_BarSet(k).Close(obj.m_BarSet(k).Iterator));
                end
            end
            % record capital
            if minute(obj.m_DrvBar.Time(i)) == 0
                %record hour capital
                obj.m_TrdSeat.recordCapital(EnumType.HOUR,obj.m_DrvBar.Time(i));
                % 15:00 record day capital then settlement
                if hour(obj.m_DrvBar.Time(i)) == 15
                    obj.m_TrdSeat.recordCapital(EnumType.DAY,obj.m_DrvBar.Time(i));
                    obj.m_TrdSeat.settlement;
                end
            end
        end
    else
        obj.m_Log.printFatal('Error! SimBench.startSimulate() can not recognize drive type %s.', ...
                             char(obj.m_DrvType));
    end
    %
    flag = 1;
    notify(obj,'e_SimExit');
end