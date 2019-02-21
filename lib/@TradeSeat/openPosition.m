function flag = openPosition(obj,instID,buysell,price,lot,opentime)
    if obj.m_RiskCtrl.isLiquidate == 1
        flag = -1;
        return;
    end
    % judge whether open position or not
    [bool,idx] = ismember(instID,obj.m_ContsTBL.ContractCode);
    if (~bool)
        obj.m_Log.printFatal('Error! Contracts table has no %s!',instID);
        flag = -2;
        return;
    end
    % calculate order margin
    if buysell == EnumType.BUY
        margin = obj.m_ContsTBL.LongMargin(idx) * price * lot * ...
                 obj.m_ContsTBL.ContractSize(idx);
    elseif buysell == EnumType.SELL
        margin = obj.m_ContsTBL.ShortMargin(idx)* price * lot * ...
                 obj.m_ContsTBL.ContractSize(idx);
    else
        obj.m_Log.printCrucial('Error! Order can not support direction : %s!',char(buysell));
        flag = -3;
        return;
    end
    % calculate open position fee
    if (obj.m_ContsTBL.OpenFee(idx) >= 0)
        fee = obj.m_ContsTBL.OpenFee(idx) * lot * (-1);
    elseif (obj.m_ContsTBL.OpenFeeRate(idx) >= 0)
        fee = obj.m_ContsTBL.OpenFeeRate(idx) * price * lot * ...
              obj.m_ContsTBL.ContractSize(idx) * (-1);
    else
        obj.m_Log.printCrucail('Warning! Trade fee or fee rate is error!');
        flag = -4;
        return;
    end
    %
    remainder = obj.m_Capital.freeMoney - margin + fee;
    if (remainder < obj.m_Capital.freeMoney * 0.4)
        flag = -5;
        return;
    end
    %
    posihdl = obj.getPosition(instID,buysell);
    if isa(posihdl,'FuturePosition')
        if (posihdl.totalLot + lot > obj.m_RiskCtrl.maxPosition)
            flag = -6;
            return;
        end
    end
    %
    order = FutureOrder(instID,EnumType.OPEN,buysell,price,lot,opentime);
    order.id = int32(rand * 100000000);
    order.margin = margin;
    order.fee = fee;
    %--------------------------------------------------------------------------
    % record trade orders
    %--------------------------------------------------------------------------
    if ~isempty(obj.m_TradeBox)
        obj.m_TradeBox = [obj.m_TradeBox;order];
    else
        obj.m_TradeBox = order;
    end
    %--------------------------------------------------------------------------
    % record open orders
    %--------------------------------------------------------------------------
    if ~isempty(obj.m_OpenBox)
        obj.m_OpenBox = [obj.m_OpenBox;order.clone];
    else
        obj.m_OpenBox = order.clone;
    end
    %--------------------------------------------------------------------------
    % handle capital
    %--------------------------------------------------------------------------
    obj.m_Capital.margin = obj.m_Capital.margin + margin;
    obj.m_Capital.fee = obj.m_Capital.fee + fee;
    obj.m_Capital.balance = obj.m_Capital.balance + fee;
    obj.m_Capital.freeMoney = obj.m_Capital.balance - obj.m_Capital.margin;
    %--------------------------------------------------------------------------
    % handle position
    %--------------------------------------------------------------------------
    finded = 0;
    for i = 1:length(obj.m_PosiBox)
        if strcmp(obj.m_PosiBox(i).instID,instID) && ...
                                (obj.m_PosiBox(i).buysell == buysell)
            finded = 1; % position has been existed.
            obj.m_PosiBox(i).avgPrice = ...
                (obj.m_PosiBox(i).avgPrice * obj.m_PosiBox(i).totalLot + price*lot) / ...
                (obj.m_PosiBox(i).totalLot + lot);
            obj.m_PosiBox(i).totalLot = obj.m_PosiBox(i).totalLot + lot;
            obj.m_PosiBox(i).todayLot = obj.m_PosiBox(i).todayLot + lot;
            obj.m_PosiBox(i).allowCloseLot = obj.m_PosiBox(i).allowCloseLot + lot;
            obj.m_PosiBox(i).margin = obj.m_PosiBox(i).margin + margin;
            break;
        end
    end
    if (finded == 0) % no position
        % create position record object
        posi = FuturePosition(instID,buysell,lot,price,margin);
        % add new position records into PosiBox
        if isempty(obj.m_PosiBox)
            obj.m_PosiBox = posi;
        else
            obj.m_PosiBox = [obj.m_PosiBox;posi];
        end
    end
    %--------------------------------------------------------------------------
    % set return flag success
    %--------------------------------------------------------------------------
    flag = 1; 
    %--------------------------------------------------------------------------
    % print open position info
    %--------------------------------------------------------------------------
    if obj.m_Debug == EnumType.ON
        obj.m_Log.printInfo('%20s %6s OPEN  %-4s %7.2f %4d', ...
                            datestr(opentime),instID,char(buysell),price,int32(lot));
    end
end