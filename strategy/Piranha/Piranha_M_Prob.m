function [tp_prob, sl_prob, count] = Piranha_M_Prob(tbl,delta,tp,sl)
    len = size(tbl,1);
    H = tbl.High;
    L = tbl.Low;
    C = tbl.Close;
    tpC = 0;
    slC = 0;
    T = 0;
    i = 3;
    while i <= (len - delta)
        if (C(i) - L(i-2) >= 3) && ...
           (L(i) > L(i-1)) && (L(i-1) > L(i-2)) && ...
           (H(i) > H(i-1)) && (H(i-1) > H(i-2)) && ...
           (C(i) > C(i-1)) && (C(i-1) > C(i-2))
            if ((hour(tbl.Time(i)) == 14) && (minute(tbl.Time(i)) > (60 - delta*5))) || ...
               ((hour(tbl.Time(i)) == 23) && (minute(tbl.Time(i)) > (30 - delta*5))) 
                i = i + delta;
                continue;
            else
                T = T + 1;
                for j = i + 1 : i + delta
                    if L(j) <= (C(i) -sl)
                        slC = slC + 1;
                        i = j;
                        break;
                    elseif H(j) >= (C(i) + tp)
                        tpC = tpC + 1;
                        i = j;
                        break;
                    end
                end
                i = i + 1;
            end
        elseif (H(i-2) - C(i) >= 3) && ...
               (L(i) < L(i-1)) && (L(i-1) < L(i-2)) && ...
               (H(i) < H(i-1)) && (H(i-1) < H(i-2)) && ...
               (C(i) < C(i-1)) && (C(i-1) < C(i-2))
            if ((hour(tbl.Time(i)) == 14) && (minute(tbl.Time(i)) > (60 - delta*5))) || ...
               ((hour(tbl.Time(i)) == 23) && (minute(tbl.Time(i)) > (30 - delta*5)))
                i = i + delta;
                continue;
            else
                T = T + 1;
                for j = i+1 : i+delta
                    if H(j) >= (C(i) + sl)
                        slC = slC + 1;
                        i = j;
                        break;
                    elseif L(j) <= (C(i) - tp)
                        tpC = tpC + 1;
                        i = j;
                        break;
                    end
                end
                i = i + 1;
            end
        else
            i = i + 1;
        end
    end
    tp_prob = tpC/T;
    sl_prob = slC/T;
    count = T;
end