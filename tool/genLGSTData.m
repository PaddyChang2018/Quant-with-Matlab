function ds = genLGSTData(O,H,L,C)
    ds = C;
    idx = (C > O);
    ds(idx) = H(idx);
    idx = (C < O);
    ds(idx) = L(idx);
    lgst = (C - L)./(H - C);
    idx = (lgst > 1.2);
    ds(idx) = H(idx);
    idx = (lgst < 0.8);
    ds(idx) = L(idx);
end