function retval = Piranha(secH,secL,secC,minH,minL,narrow,wide)
    flag = 0;
    sellPrc = 0;
    buyPrc = 0;
    tpDelta = 0;
    tySecMx = max(secH(end-4:end));
    tySecMn = min(secL(end-4:end));
%     tySecRge = tySecMx - tySecMn;
%     bigSecRge = max(secH) - min(secL);
    minRange = max(minH) - min(minL);
    %
%     if (tySecRge >= 3)
%         if secC(end) - secC(end-4) >= 2
%             flag = 1;
%             sellPrc = 0;
%             buyPrc = tySecMx - 1;
%             tpDelta = 3;
%             retval = [flag,sellPrc,buyPrc,tpDelta];
%             return;
%         elseif secC(end) - secC(end-4) <= -2
%             flag = -1;
%             sellPrc = tySecMn + 1;
%             buyPrc = 0;
%             tpDelta = 3;
%             retval = [flag,sellPrc,buyPrc,tpDelta];
%             return;
%         end
%     end
    %
    if (minH(end - 1) > minH(end - 2)) && (minL(end - 1) > minL(end - 2)) % Up trend
        if abs(secC(end) - tySecMx) <= 1
            flag = 1;
            sellPrc = 0;
            buyPrc = secC(end);
            tpDelta = 2;
        end
    elseif (minH(end - 1) < minH(end - 2)) && (minL(end - 1) < minL(end - 2)) % Down trend
        if abs(secC(end) - tySecMn) <= 1
            flag = -1;
            sellPrc = secC(end);
            buyPrc = 0;
            tpDelta = 2;
        end
    else     % no obvious trend
        if (minRange <= narrow)
%             if (bigSecRge <= 2)
%                 flag = 2;
%                 sellPrc = max(minH(end-4:end));
%                 buyPrc = min(minL(end-4:end));
%                 tpDelta = 1;
%             end
        elseif (minRange >= wide)
            if abs(secC(end) - min(minL)) <= 1
                flag = -1;
                sellPrc = secC(end); 
                buyPrc = 0;
                tpDelta = 2;
            elseif abs(max(minH) - secC(end)) <= 1
                flag = 1;
                sellPrc = 0;
                buyPrc = secC(end);
                tpDelta = 2;
            end
        end
    end
    %
    retval = [flag,sellPrc,buyPrc,tpDelta];
end