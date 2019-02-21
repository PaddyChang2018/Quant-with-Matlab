function iterateBar(tbl,itN)
    len = size(tbl,1);
    nopen = zeros(len,1);
    nhigh = zeros(len,1);
    nlow = zeros(len,1);
    %
    nopen(1:itN-1) = tbl.Open(1:itN-1);
    nhigh(1:itN-1) = tbl.High(1:itN-1);
    nlow(1:itN-1) = tbl.Low(1:itN-1);
    %
    for i = itN : len
        nopen(i) = tbl.Open(i-itN+1);
        nhigh(i) = max(tbl.High(i-itN+1:i));
        nlow(i) = min(tbl.Low(i-itN+1:i));
    end
    drawCandle(tbl.Open,tbl.High,tbl.Low,tbl.Close);
    drawCandle(nopen,nhigh,nlow,tbl.Close);
end