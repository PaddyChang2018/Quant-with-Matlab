function fighdl = drawCandle(obj)
    if isempty(obj.Close) 
        obj.Log.printInfo('Warning! BarSeries.drawCandle has no data.');
        return;
    end
    len = length(obj.Close);
    up = find(obj.Open < obj.Close); 
    down = find(obj.Close < obj.Open); 
    equal = find(obj.Close == obj.Open);
    data = [obj.High,obj.Low,obj.Close,obj.Open];
    Mtx1 = zeros(len,4); 
    Mtx2 = zeros(len,4);
    Mtx3 = zeros(len,4);
    Mtx1(up,:) = data(up,:);
    Mtx2(down,:) = data(down,:);
    Mtx3(equal,:) = data(equal,:);
    ma = max(obj.High);
    mi = min(obj.Low);
    range = ma - mi;
    if len > 7
        x = 1:int32(floor(len/7)):len;
    else
        x = 1:len;
    end
    ds = datestr(obj.Time);
    dateSA = cell(length(x),1);
    for i=1:length(x)
        dateSA{i} = ds(x(i),:);
    end
    %
    fighdl = figure;
    candle(Mtx1(:,1),Mtx1(:,2),Mtx1(:,3),...
           Mtx1(:,4),'r');
    hold on
    candle(Mtx2(:,1),Mtx2(:,2),Mtx2(:,3),...
           Mtx2(:,4),'b');
    hold on
    candle(Mtx3(:,1),Mtx3(:,2),Mtx3(:,3),...
           Mtx3(:,4),'k');
    axis([1, len, mi-0.075*range, ma+0.075*range]);
    title([obj.InstID,' ',char(obj.TimeFrame)]);
    xlabel('Time Series');
    ylabel('Price');
    grid;
    set(gca,'XTick',x);
    set(gca,'XTickLabel',dateSA);
end