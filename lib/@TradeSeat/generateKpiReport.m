function generateKpiReport(obj,reportFile)
    if nargin == 1
        rptFile = 'Report.txt';
    elseif nargin == 2
        rptFile = reportFile;
    else
        obj.m_Log.printFatal('Error! generateKpiReport() only accept 0/1 input arguments.');
        return;
    end
    %
    if isempty(obj.m_CloseBox)
        return;
    end
    gainOrdsPft = 0;
    deficitOrdsLoss = 0;
    gainNum = 0;
    longNum = 0;
    shortNum = 0;
    longGainNum = 0;
    shortGainNum = 0;
    maxGainOrd = 0;
    maxLossOrd = 0;
    contiWinNum = 0;
    contiLossNum = 0;
    maxContiWinNum = 0;
    maxContiWinNumMoney = 0;
    maxContiLossNum = 0;
    maxContiLossNumMoney = 0;
    maxContiWinMoney = 0;
    maxContiWinMoneyNum = 0;
    maxContiLossMoney = 0;
    maxContiLossMoneyNum = 0;
    contiWinSetCount = 0;
    contiLossSetCount = 0;
    totalContiWinOrdNum = 0;
    totalContiLossOrdNum = 0;
    ordsNum = length(obj.m_CloseBox);
    pftN = zeros(ordsNum,1);
    % -----------------------Orders-------------------------
    for i = 1:ordsNum
        pftN(i) = obj.m_CloseBox(i).profit;
        %
        if pftN(i) >= 0
            gainOrdsPft = gainOrdsPft + pftN(i);
            gainNum = gainNum + 1;
            if obj.m_CloseBox(i).buysell == EnumType.BUY 
                longNum = longNum + 1;
                longGainNum = longGainNum + 1;
            else
                shortNum = shortNum + 1;
                shortGainNum = shortGainNum + 1;
            end
            if pftN(i) > maxGainOrd
                maxGainOrd = pftN(i);
            end
            %
            if contiLossNum > 1
                sumMoney = sum(pftN(i-contiLossNum:i-1));
                if maxContiLossNum < contiLossNum
                    maxContiLossNum = contiLossNum;
                    maxContiLossNumMoney = sumMoney;
                end
                if maxContiLossMoney > sumMoney
                    maxContiLossMoney = sumMoney;
                    maxContiLossMoneyNum = contiLossNum;
                end
                totalContiLossOrdNum = totalContiLossOrdNum + contiLossNum;
                contiLossSetCount =  contiLossSetCount + 1;
            end
            contiLossNum = 0;
            contiWinNum = contiWinNum + 1;
        else
            deficitOrdsLoss = deficitOrdsLoss + pftN(i);
            if obj.m_CloseBox(i).buysell == EnumType.BUY 
                longNum = longNum + 1;
            else
                shortNum = shortNum + 1;
            end
            if pftN(i) < maxLossOrd
                maxLossOrd = pftN(i);
            end
            %
            if contiWinNum > 1
                sumMoney = sum(pftN(i-contiWinNum:i-1));
                if maxContiWinNum < contiWinNum
                    maxContiWinNum = contiWinNum;
                    maxContiWinNumMoney = sumMoney;
                end
                if maxContiWinMoney < sumMoney
                    maxContiWinMoney = sumMoney;
                    maxContiWinMoneyNum = contiWinNum;
                end
                totalContiWinOrdNum = totalContiWinOrdNum + contiWinNum;
                contiWinSetCount = contiWinSetCount + 1;
            end
            contiWinNum = 0; 
            contiLossNum = contiLossNum + 1;
        end
        %
    end
    %
    totalFee = 0;
    for i = 1 : length(obj.m_TradeBox)
        totalFee = totalFee + obj.m_TradeBox(i).fee;
    end
    netPft = obj.m_Capital.balance - obj.m_Capital.deposit;
    netIPY = netPft/obj.m_Capital.deposit;
    ordPft = gainOrdsPft + deficitOrdsLoss;
    period = days(obj.m_CloseBox(end).closeTime - obj.m_CloseBox(1).openTime);
    netMMY = netIPY*360/period;
    pftFactor = abs(gainOrdsPft/deficitOrdsLoss);
    avgGainPerOrd = ordPft/ordsNum;
    winRate = gainNum/ordsNum;
    gainAvgPft = gainOrdsPft/gainNum;
    lossAvgPft = deficitOrdsLoss/(ordsNum - gainNum);
    gainLossRatio = gainAvgPft/lossAvgPft;
    avgContiWinOrdNum = totalContiWinOrdNum/contiWinSetCount;
    avgContiLossOrdNum = totalContiLossOrdNum/contiLossSetCount;
    avgOrdsPerDay = ordsNum/ceil(period);
    %
    S = length(obj.m_CapiDayBox);
    balcN = zeros(S,1);
    for i = 1:S
        balcN(i) = obj.m_CapiDayBox(i).capital.balance;
    end
    depo = obj.m_Capital.deposit;
    capiDiff = [balcN(1)-depo; balcN(2:end) - balcN(1:end-1)];
    capiVarN = [capiDiff(1)/depo; capiDiff(2:end)./balcN(1:end-1)];
    [bestDayPft,bestDayPftIdx] = max(capiDiff);
    [worstDayPft,worstDayPftIdx] = min(capiDiff);
    [bestDayPct,bestDayPctIdx] = max(capiVarN);
    [worstDayPct,worstDayPctIdx] = min(capiVarN);
    % -----------------------generate report.txt--------------------------
    fid = fopen(rptFile,'a');
    fprintf(fid,'----------------Investment Report %s-----------------\r\n',datestr(now));
    fprintf(fid,'Investment Period Yield : %0.2f%%\r\n',netIPY*100);
    fprintf(fid,'Money Market Annual Yield  : %0.2f%%\r\n',netMMY*100);
    fprintf(fid,'Net Profit : %0.2f\r\n',netPft);
    fprintf(fid,'Close Order Profit : %0.2f\r\n',ordPft);
    fprintf(fid,'Total Fee : %0.2f\r\n',totalFee);
    fprintf(fid,'Gain Orders Profit : %0.2f\r\n',gainOrdsPft);
    fprintf(fid,'Deficit Orders Loss : %0.2f\r\n',deficitOrdsLoss);
    fprintf(fid,'Profit Factor : %0.2f\r\n',pftFactor);
    fprintf(fid,'Average Gain Per Order : %0.2f\r\n',avgGainPerOrd);
    fprintf(fid,'Absolute Drawdown : %0.2f\r\n', obj.m_KPI.absDrawdown);
    fprintf(fid,'Max Drawdown : %0.2f%%\r\n', maxdrawdown(balcN)*100);
    fprintf(fid,'Max Float Gain : %0.2f\r\n',obj.m_KPI.maxFloatGain);
    fprintf(fid,'Max Float Loss : %0.2f\r\n',obj.m_KPI.maxFloatLoss);
    fprintf(fid,'Min Free Money Rate : %0.2f%%\r\n', ...
                obj.m_KPI.minFreeMoneyRate*100);
    fprintf(fid,'Best Day Profit : %0.2f(%s)\r\n', ...
                bestDayPft,datestr(obj.m_CapiDayBox(bestDayPftIdx).time));
    fprintf(fid,'Worst Day Profit : %0.2f(%s)\r\n', ...
                worstDayPft,datestr(obj.m_CapiDayBox(worstDayPftIdx).time));
    fprintf(fid,'Best Balance variation : %0.2f%%(%s)\r\n', ...
                bestDayPct*100,datestr(obj.m_CapiDayBox(bestDayPctIdx).time));
    fprintf(fid,'Worst Balance variation : %0.2f%%(%s)\r\n', ...
                worstDayPct*100,datestr(obj.m_CapiDayBox(worstDayPctIdx).time));
    fprintf(fid,'Total Orders Num : %d\r\n',ordsNum);
    fprintf(fid,'Average open orders per day : %0.2f\r\n',avgOrdsPerDay);
    fprintf(fid,'Long Orders Num(won%%) : %d(%0.2f%%)\r\n',longNum,(longGainNum/longNum)*100);
    fprintf(fid,'Short Orders Num(won%%) : %d(%0.2f%%)\r\n',shortNum,(shortGainNum/shortNum)*100);
    fprintf(fid,'Gain Orders Num(%% of total) : %d(%0.2f%%)\r\n',gainNum,(gainNum/ordsNum)*100);
    fprintf(fid,'Loss Orders Num(%% of total) : %d(%0.2f%%)\r\n',ordsNum-gainNum,(1-(gainNum/ordsNum))*100);
    fprintf(fid,'Win Rate : %0.2f%%\r\n',winRate*100);
    fprintf(fid,'Max Profit One Order : %0.2f\r\n',maxGainOrd);
    fprintf(fid,'Max Loss One Order: %0.2f\r\n',maxLossOrd);
    fprintf(fid,'Gain Order Average Profit : %0.2f\r\n',gainAvgPft);
    fprintf(fid,'Deficit Order Average Loss : %0.2f\r\n',lossAvgPft);
    fprintf(fid,'Gain/Loss Ratio : %0.2f\r\n',abs(gainLossRatio));
    fprintf(fid,'Max consecutive wins(Profit) : %d(%0.2f)\r\n', ...
                maxContiWinNum,maxContiWinNumMoney);
    fprintf(fid,'Max consecutive losses (loss) : %d(%0.2f)\r\n', ...
                maxContiLossNum,maxContiLossNumMoney);
    fprintf(fid,'Max consecutive profit (count of wins) : %0.2f(%d)\r\n', ...
                maxContiWinMoney,maxContiWinMoneyNum);
    fprintf(fid,'Max consecutive loss (count of losses) : %0.2f(%d)\r\n', ...
                maxContiLossMoney,maxContiLossMoneyNum);
    fprintf(fid,'Average consecutive win order num : %0.2f\r\n', ...
                avgContiWinOrdNum); 
    fprintf(fid,'Average consecutive loss order num : %0.2f\r\n', ...
                avgContiLossOrdNum);
    fprintf(fid,'-----------------------------------------------------------------------\r\n');
    fclose(fid);
    % -----------------------generate report to stdio--------------------------
    obj.m_Log.printCrucial('----------------Investment Report %s-----------------', ...
                         datestr(now));
    obj.m_Log.printCrucial('Investment Period Yield : %0.2f%%',netIPY*100);
    obj.m_Log.printCrucial('Money Market Annual Yield  : %0.2f%%',netMMY*100);
    obj.m_Log.printCrucial('Net Profit : %0.2f',netPft);
    obj.m_Log.printCrucial('Close Order Profit : %0.2f',ordPft);
    obj.m_Log.printCrucial('Total Fee : %0.2f',totalFee);
    obj.m_Log.printCrucial('Gain Orders Profit : %0.2f',gainOrdsPft);
    obj.m_Log.printCrucial('Deficit Orders Loss : %0.2f',deficitOrdsLoss);
    obj.m_Log.printCrucial('Profit Factor : %0.2f',pftFactor);
    obj.m_Log.printCrucial('Average Gain Per Order : %0.2f',avgGainPerOrd);
    obj.m_Log.printCrucial('Absolute Drawdown : %0.2f', obj.m_KPI.absDrawdown);
    obj.m_Log.printCrucial('Max Drawdown : %0.2f%%', maxdrawdown(balcN)*100);
    obj.m_Log.printCrucial('Max Float Gain : %0.2f',obj.m_KPI.maxFloatGain);
    obj.m_Log.printCrucial('Max Float Loss : %0.2f',obj.m_KPI.maxFloatLoss);
    obj.m_Log.printCrucial('Min Free Money Rate : %0.2f%%', ...
                          obj.m_KPI.minFreeMoneyRate*100);
    obj.m_Log.printCrucial('Best Day Profit : %0.2f(%s)', ...
                         bestDayPft,datestr(obj.m_CapiDayBox(bestDayPftIdx).time));
    obj.m_Log.printCrucial('Worst Day Profit : %0.2f(%s)', ...
                         worstDayPft,datestr(obj.m_CapiDayBox(worstDayPftIdx).time));
    obj.m_Log.printCrucial('Best Balance variation : %0.2f%%(%s)', ...
                         bestDayPct*100,datestr(obj.m_CapiDayBox(bestDayPctIdx).time));
    obj.m_Log.printCrucial('Worst Balance variation : %0.2f%%(%s)', ...
                         worstDayPct*100,datestr(obj.m_CapiDayBox(worstDayPctIdx).time));
    obj.m_Log.printCrucial('Total Orders Num : %d',ordsNum);
    obj.m_Log.printCrucial('Average open orders per day : %0.2f',avgOrdsPerDay);
    obj.m_Log.printCrucial('Long Orders Num(won%%) : %d(%0.2f%%)', ...
                         longNum,(longGainNum/longNum)*100);
    obj.m_Log.printCrucial('Short Orders Num(won%%) : %d(%0.2f%%)', ...
                         shortNum,(shortGainNum/shortNum)*100);
    obj.m_Log.printCrucial('Gain Orders Num(%% of total) : %d(%0.2f%%)', ...
                         gainNum,(gainNum/ordsNum)*100);
    obj.m_Log.printCrucial('Loss Orders Num(%% of total) : %d(%0.2f%%)', ...
                         ordsNum-gainNum,(1-(gainNum/ordsNum))*100);
    obj.m_Log.printCrucial('Win Rate : %0.2f%%',winRate*100);
    obj.m_Log.printCrucial('Max Profit One Order : %0.2f',maxGainOrd);
    obj.m_Log.printCrucial('Max Loss One Order: %0.2f',maxLossOrd);
    obj.m_Log.printCrucial('Gain Order Average Profit : %0.2f',gainAvgPft);
    obj.m_Log.printCrucial('Deficit Order Average Loss : %0.2f',lossAvgPft);
    obj.m_Log.printCrucial('Gain/Loss Ratio : %0.2f',abs(gainLossRatio));
    obj.m_Log.printCrucial('Max consecutive wins(Profit) : %d(%0.2f)', ...
                         maxContiWinNum,maxContiWinNumMoney);
    obj.m_Log.printCrucial('Max consecutive losses (loss) : %d(%0.2f)', ...
                         maxContiLossNum,maxContiLossNumMoney);
    obj.m_Log.printCrucial('Max consecutive profit (count of wins) : %0.2f(%d)', ...
                         maxContiWinMoney,maxContiWinMoneyNum);
    obj.m_Log.printCrucial('Max consecutive loss (count of losses) : %0.2f(%d)', ...
                         maxContiLossMoney,maxContiLossMoneyNum);
    obj.m_Log.printCrucial('Average consecutive win order num : %0.2f', ...
                         avgContiWinOrdNum); 
    obj.m_Log.printCrucial('Average consecutive loss order num : %0.2f', ...
                         avgContiLossOrdNum);
    obj.m_Log.printCrucial('-----------------------------------------------------------------------');
end