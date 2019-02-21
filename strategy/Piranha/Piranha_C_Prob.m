function [win_prob, count, netpft] = Piranha_C_Prob(tbl,tp,sl)
    % contract info
    contsize = 10;
    feelot = 1.32;
    %
    len = size(tbl,1);
    H = tbl.High;
    L = tbl.Low;
    C = tbl.Close;
    LongPosi = 0;
    ShortPosi = 0;
    LongOpenPrc = 0;
    ShortOpenPrc = 0;
    profit = 0;
    fee = 0;
    winC = 0;
    totalC = 0;
    %
    for i = 3 : len
        % only calculate daytime 
        if (hour(tbl.Time(i)) >= 15) || (hour(tbl.Time(i)) < 9)
            continue;
        end
        % close all position at 14:58 using close price
        % OnBar trigger
        if ((hour(tbl.Time(i)) == 14) && (minute(tbl.Time(i)) >= 58))
            if LongPosi > 0
                profit = profit + (C(i) - LongOpenPrc) * LongPosi * contsize;
                fee = fee - feelot;
                if (C(i) - LongOpenPrc) * LongPosi * contsize - feelot > 0
                    winC = winC + 1;
                end
                LongPosi = 0;
            end
            if ShortPosi > 0
                profit = profit + (ShortOpenPrc - C(i)) * ShortPosi * contsize;
                fee = fee - feelot;
                if (ShortOpenPrc - C(i)) * ShortPosi * contsize - feelot > 0
                    winC = winC + 1;
                end
                ShortPosi = 0;
            end
            continue;
        end
        % stop loss first, take profit second at daytime, using high/low price
        % OnTick trigger
        if LongPosi > 0
            if L(i) <= LongOpenPrc - sl
                profit = profit - sl * LongPosi * contsize;
                fee = fee - feelot;
                LongPosi = 0;
            elseif H(i) >= LongOpenPrc + tp
                profit = profit + tp * LongPosi * contsize;
                fee = fee - feelot;
                winC = winC + 1;
                LongPosi = 0;
            end
        end
        if ShortPosi > 0
            if H(i) >= ShortOpenPrc + sl
                profit = profit - sl * ShortPosi * contsize;
                fee = fee - feelot;
                ShortPosi = 0;
            elseif L(i) <= ShortOpenPrc - tp
                profit = profit + tp * ShortPosi * contsize;
                fee = fee - feelot;
                winC = winC + 1;
                ShortPosi = 0;
            end
        end
        % do not open position after 11:20 - 11:30
        if (hour(tbl.Time(i)) == 11) && (minute(tbl.Time(i)) > 20)
            continue;
        end
        % open long position
        if (C(i) - L(i-2) >= 3) && ...
           (L(i) > L(i-1)) && (L(i) > L(i-2)) && ...
           (H(i) > H(i-1)) && (H(i) > H(i-2)) && ...
           (C(i) > C(i-1)) && (C(i) > C(i-2)) && (LongPosi == 0)
            % close short position
            if ShortPosi > 0
                profit = profit + (ShortOpenPrc - C(i)) * ShortPosi * contsize;
                fee = fee - feelot; 
                if (ShortOpenPrc - C(i)) * ShortPosi * contsize - feelot > 0
                    winC = winC + 1;
                end
                ShortPosi = 0;
            end
            LongOpenPrc = C(i);
            totalC = totalC + 1;
            LongPosi = LongPosi + 1;
        % open short position
        elseif (H(i-2) - C(i) >= 3) && ...
               (L(i) < L(i-1)) && (L(i) < L(i-2)) && ...
               (H(i) < H(i-1)) && (H(i) < H(i-2)) && ...
               (C(i) < C(i-1)) && (C(i) < C(i-2)) && (ShortPosi == 0)
            if LongPosi > 0
                profit = profit + (C(i) - LongOpenPrc) * LongPosi * contsize;
                fee = fee - feelot;
                if (C(i) - LongOpenPrc) * LongPosi * contsize - feelot > 0
                    winC = winC + 1;
                end
                LongPosi = 0;
            end
            ShortOpenPrc = C(i);
            totalC = totalC + 1;
            ShortPosi = ShortPosi + 1;
        end
    end
    win_prob = winC/totalC;
    count = totalC;
    netpft = profit + fee;
end