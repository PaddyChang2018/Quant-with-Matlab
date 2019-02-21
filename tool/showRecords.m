function pips = showRecords(rcd)
    len = size(rcd,1);
    pips = zeros(floor(len/2),1);
    pi = 1;
    for i = 1 : len
        if rcd.OC(i) == 0
            if rcd.LS(i) == 1
                pips(pi) = rcd.Price(i-1) - rcd.Price(i);
                pi = pi + 1;
            elseif rcd.LS(i) == -1
                pips(pi) = rcd.Price(i) - rcd.Price(i-1);
                pi = pi + 1;
            end
        end
    end
    sumpips = cumsum(pips);
    figure;
    plot(sumpips);
    grid;
end