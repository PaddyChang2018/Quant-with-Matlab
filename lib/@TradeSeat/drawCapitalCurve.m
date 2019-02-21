function drawCapitalCurve(obj,timeType)
    if nargin == 1
        timeT = EnumType.DAY;
    elseif nargin == 2
        timeT = timeType;
    else
        obj.m_Log.printCrucail('Warning! drawCapitalCurve() only accept 0/1 input arguments.');
        return;
    end
    %
    if timeT == EnumType.DAY
        capiBox = obj.m_CapiDayBox;
        format = 'yyyymmdd';
        interval = 10;
        tmtyStr = 'Daily';
    elseif timeT == EnumType.HOUR
        capiBox = obj.m_CapiHourBox;
        format = 'yyyymmdd HH:MM';
        interval = 7;
        tmtyStr = 'Hour';
    else
        obj.m_Log.printCrucial('Warning! drawCapitalCurve() only support day or hour time type.');
        return;
    end
    %
    s = length(capiBox);
    balcN = zeros(s,1);
    depoN = zeros(s,1);
    dateS = cell(s,1);
    for i = 1:s
        balcN(i) = capiBox(i).capital.balance;
        depoN(i) = capiBox(i).capital.deposit;
        dateS{i} = datestr(capiBox(i).time,format);
    end
    %
    if s > interval
        X = 1:int32(floor(s/interval)):s;
    else
        X = 1:s;
    end
    dateSA = cell(length(X),1);
    for i=1:length(X)
        dateSA{i} = dateS{X(i)};
    end
    capiRate = [1;balcN./depoN];
    range = max(capiRate)-min(capiRate);
    figure;
    hp = plot(0:s,capiRate,'r');
    legend('Capital Ratio');
    if range ~= 0
        axis([0,s,min(capiRate)-0.05*range,max(capiRate)+0.05*range]);
    end
    hp.LineWidth = 2;
    grid;
    title([tmtyStr,' Capital Curve']);
    set(gca,'XTick',X);
    set(gca,'XTickLabel',dateSA);
    xlabel(['Time(',tmtyStr,')']);
end