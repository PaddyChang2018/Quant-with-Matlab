function normdata = normCtpData(ctpdata,timeframe)
    if timeframe == EnumType.D1 || timeframe == EnumType.W1
        ts = datetime(ctpdata.TradingDay,'InputFormat','yyyyMMdd');
    else
        ts = datetime(strcat(ctpdata.TradingDay,'-',ctpdata.TradingTime), ...
                      'InputFormat', ...
                      'yyyyMMdd-HHmm');
    end
    %
    idx = find(hour(ts)>15);
    for i = 1:length(idx)
        ts(idx(i)) = ts(idx(i)) - days(1);
    end
    %
    tbl = table(ts,ctpdata.OpenPrice,ctpdata.HighestPrice, ...
                ctpdata.LowestPrice,ctpdata.ClosePrice, ...
                ctpdata.Volume,ctpdata.Turnover,'VariableNames', ...
                {'Time','Open','High','Low','Close','Volume','Turnover'});
    % delete invalid rows
%     if timeframe ~= EnumType.D1 && timeframe ~= EnumType.W1
%         i = 1;
%         while i <= size(tbl,1)
%             if ((hour(tbl.Time(i)) ==23) && (minute(tbl.Time(i)) > 30)) || ...
%                (hour(tbl.Time(i)) < 9) || ((hour(tbl.Time(i))>15) && (hour(tbl.Time(i))<21)) || ...
%                ((hour(tbl.Time(i)) == 9) && (minute(tbl.Time(i)) == 0)) || ...
%                ((hour(tbl.Time(i)) == 21) && (minute(tbl.Time(i)) == 0))
%                 % delete i row data
%                 tbl = [tbl(1:i-1,:);tbl(i+1:end,:)];
%             else
%                 i = i + 1;
%             end
%         end
%     end
    % return normal table data
    normdata = tbl;
end