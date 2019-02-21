function ntbl = normTdxData(tbl,timeframe)
    if nargin == 2
        if timeframe == EnumType.D1
            ts = datetime(tbl.TradingDay,'InputFormat','yyyy/MM/dd');
            ntbl = table(ts,tbl.Open, tbl.High, tbl.Low, tbl.Close, tbl.Volume, ...
                 tbl.OpenInterest, tbl.Settlement, 'VariableNames', ...
                 {'Time','Open','High','Low','Close','Volume','OpenInterest','Settlement'});
        else
            ts = datetime(strcat(tbl.TradingDay,'-',tbl.TradingTime), ...
                          'InputFormat', 'yyyy/MM/dd-HHmm');
            % norm ctp time to nature time : hour > 15
%             idx = find(hour(ts)>15);
%             ts(idx) = ts(idx) - days(1);
            ntbl = table(ts,tbl.Open,tbl.High,tbl.Low,tbl.Close,tbl.Volume,tbl.OpenInterest, ...
                        'VariableNames',{'Time','Open','High','Low','Close','Volume','OpenInterest'});
        end
    else
        ts = datetime(strcat(tbl.TradingDay,'-',tbl.TradingTime), ...
                      'InputFormat', 'yyyy/MM/dd-HHmm');       
        % transform ctp time to nature time : hour > 15
%         idx = find(hour(ts)>15);
%         ts(idx) = ts(idx) - days(1);
        ntbl = table(ts,tbl.Open,tbl.High,tbl.Low,tbl.Close,tbl.Volume,tbl.OpenInterest, ...
                    'VariableNames',{'Time','Open','High','Low','Close','Volume','OpenInterest'});
    end
    % delete Volume = 0 data records
    % ntbl = ntbl(ntbl.Volume > 0,:);
end