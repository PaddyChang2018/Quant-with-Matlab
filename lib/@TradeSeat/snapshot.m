function snapshot(obj,instID,price)
    %---------------------------------------------------------------------------
    % judge position whether is empty or not
    %---------------------------------------------------------------------------
    if isempty(obj.m_PosiBox)
        %-----------------------------------------------------------------------
        % update capital default
        %-----------------------------------------------------------------------
        obj.m_Capital.openPosiGain = 0;
        obj.m_Capital.balance = obj.m_Capital.settle + obj.m_Capital.closePosiGain + ...
                                obj.m_Capital.fee;
        obj.m_Capital.freeMoney = obj.m_Capital.balance - obj.m_Capital.margin;
        %-----------------------------------------------------------------------
        % update risk control
        %-----------------------------------------------------------------------
        if obj.m_Capital.balance < obj.m_Capital.deposit * obj.m_RiskCtrl.liquidatePercent
            if obj.m_RiskCtrl.isLiquidate ~= 1
                obj.m_Log.printFatal('snapshot() touch liquidate percent %0.2f%%!', ...
                                     obj.m_RiskCtrl.liquidatePercent*100);
            end
            obj.m_RiskCtrl.isLiquidate = 1;
        else
            obj.m_RiskCtrl.isLiquidate = 0;
        end
        return;
    end   
    %
    update = 0;
    for i=1:length(obj.m_PosiBox)
        if strcmp(obj.m_PosiBox(i).instID,instID)
            %-------------------------------------------------------------------
            % update position profit
            %-------------------------------------------------------------------
            if obj.m_PosiBox(i).buysell == EnumType.BUY
                priceDiff = price - obj.m_PosiBox(i).avgPrice;
            elseif obj.m_PosiBox(i).buysell == EnumType.SELL
                priceDiff = obj.m_PosiBox(i).avgPrice - price;
            else
                obj.m_Log.printCrucial('Error! %s position should be buy or sell type.', ...
                                       obj.m_PosiBox(i).instID);
                return;
            end
            [bool,idx] = ismember(instID,obj.m_ContsTBL.ContractCode);
            if (~bool)
                obj.m_Log.printFatal('Error! Contracts table has no %s!',instID);
                return;
            end
            obj.m_PosiBox(i).profit = priceDiff * obj.m_PosiBox(i).totalLot * ...
                                      obj.m_ContsTBL.ContractSize(idx);
            %-------------------------------------------------------------------
            % update capital openPosiGain 
            %-------------------------------------------------------------------
            obj.m_Capital.openPosiGain = obj.m_Capital.openPosiGain + obj.m_PosiBox(i).profit;
            update = 1;
        end
    end
    %
    if update == 0
        return;
    end
    %---------------------------------------------------------------------------
    % update capital
    %---------------------------------------------------------------------------
    obj.m_Capital.balance = obj.m_Capital.settle + obj.m_Capital.closePosiGain + ...
                            obj.m_Capital.openPosiGain + obj.m_Capital.fee;
    obj.m_Capital.freeMoney = obj.m_Capital.balance - obj.m_Capital.margin;
    %---------------------------------------------------------------------------
    % update risk control
    %---------------------------------------------------------------------------
    if obj.m_Capital.balance < obj.m_Capital.deposit * obj.m_RiskCtrl.liquidatePercent
        if obj.m_RiskCtrl.isLiquidate ~= 1
            obj.m_Log.printFatal('snapshot() touch liquidate percent %0.2f%%!', ...
                                 obj.m_RiskCtrl.liquidatePercent*100);
        end
        obj.m_RiskCtrl.isLiquidate = 1;
    else
        obj.m_RiskCtrl.isLiquidate = 0;
    end   
    %---------------------------------------------------------------------------
    % update KPI
    %---------------------------------------------------------------------------
    if obj.m_KPI.maxFloatLoss > obj.m_Capital.openPosiGain
        obj.m_KPI.maxFloatLoss = obj.m_Capital.openPosiGain;
    end
    if obj.m_KPI.maxFloatGain < obj.m_Capital.openPosiGain
        obj.m_KPI.maxFloatGain = obj.m_Capital.openPosiGain;
    end
    freeMoneyRate = obj.m_Capital.freeMoney / obj.m_Capital.balance;
    if obj.m_KPI.minFreeMoneyRate > freeMoneyRate 
        obj.m_KPI.minFreeMoneyRate = freeMoneyRate;
    end
    absDD = obj.m_Capital.balance - obj.m_Capital.deposit;
    if (absDD < 0) && (obj.m_KPI.absDrawdown > absDD)  
        obj.m_KPI.absDrawdown = absDD;
    end
end