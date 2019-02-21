function bstbl = getBarSeries(obj,instID,timeframe,interval,len)
    itime = zeros(len,1);
    iopen = zeros(len,1);
    ihigh = zeros(len,1);
    ilow = zeros(len,1);
    iclose = zeros(len,1);
    ivolume = zeros(len,1);
    iturnover = zeros(len,1);
    for i = 1 : length(obj.m_BarSet)
        if (strcmp(obj.m_BarSet(i).InstID,instID)) && ...
                (obj.m_BarSet(i).TimeFrame == timeframe)
            bs = obj.m_BarSet(i);
            bgnidx = bs.Iterator - mod(bs.Iterator,interval) - interval * len + 1;
            if bgnidx > 0
                k = 1;
                for j = bgnidx : interval : (bs.Iterator - mod(bs.Iterator,interval))
                    itime(k) = bs.Time(j+interval-1);
                    iopen(k) = bs.Open(j);
                    ihigh(k) = max(bs.High(j:j+interval-1));
                    ilow(k) = min(bs.Low(j:j+interval-1));
                    iclose(k) = bs.Close(j+interval-1);
                    ivolume(k) = sum(bs.Volume(j:j+interval-1));
                    iturnover(k) = sum(bs.Turnover(j:j+interval-1));
                    k = k + 1;
                end
                % create table
                bstbl = table(itime,iopen,ihigh,ilow,iclose,ivolume,iturnover, ...
                              'VariableNames', ...
                              {'Time','Open','High','Low','Close','Volume','Turnover'});
            else
                obj.m_Log.printFatal('Error! SimBench.getBarSeries() has not enough data for %d %s %d-%s requirement.', ...
                                     len,instID,interval,char(timeframe));
            end
            return;
        end
    end
    obj.m_Log.printFatal('Error! SimBench.getBarSeries() did not book %s %d-%s bar series.', ...
                         instID,interval,char(timetype));
end