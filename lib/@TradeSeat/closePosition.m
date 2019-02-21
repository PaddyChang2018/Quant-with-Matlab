function flag = closePosition(obj,instID,buysell,price,lot,closetime,varargin)
    % judge whether open position or not
    [bool,idx] = ismember(instID,obj.m_ContsTBL.ContractCode);
    if (~bool)
        obj.m_Log.printFatal('Error! Contracts table has no %s!',instID);
        flag = -1;
        return;
    end
    % Calculate allow close position lots
    if buysell == EnumType.BUY
        rvt = EnumType.SELL;
    elseif buysell == EnumType.SELL
        rvt = EnumType.BUY;
    else
        flag = -2;
        obj.m_Log.printFatal('Error! closePosition() can not support buysell type:%s',char(buysell));
        return;
    end
    posihdl = obj.getPosition(instID,rvt);
    if ~isa(posihdl,'FuturePosition')
        flag = -3;
        obj.m_Log.printFatal('Error! closePosition() can not find %s %s position.', ...
                             instID,char(rvt));
        return;
    end
    %
    if posihdl.allowCloseLot == 0
        flag = -4;
        if buysell == EnumType.BUY
            obj.m_Log.printFatal('Error! There are no %s %s position to close.', ...
                                  instID,char(EnumType.SELL));
        else
            obj.m_Log.printFatal('Error! There are no %s %s position to close.', ...
                                  instID,char(EnumType.BUY));
        end
        return;
    elseif posihdl.allowCloseLot >= lot
        openlot = lot;
    else
        if ~isempty(varargin)
            if varargin{1} == EnumType.FAK
                openlot = posihdl.allowCloseLot;
                lot = posihdl.allowCloseLot;
            else
                flag = -5;
                obj.m_Log.printFatal('Error! There are not enough %s to close.',instID);                    
                return;
            end
        else
            flag = -6;
            obj.m_Log.printFatal('Error! There are not enough %s to close.',instID);
            return;
        end
    end
    %
    i = 1;
    while ((i <= length(obj.m_OpenBox)) && (openlot > 0))
        if strcmp(obj.m_OpenBox(i).instID,instID)
            if buysell == EnumType.BUY 
                if obj.m_OpenBox(i).buysell == EnumType.SELL
                    % clone open order to close order
                    clsOrder = obj.m_OpenBox(i).clone;
                    clsOrder.closePrice = price;
                    clsOrder.closeTime = closetime;
                    if clsOrder.lot >= openlot
                        clsOrder.lot = openlot;
                    end
                    % calculate close order profit
                    clsOrder.profit = (clsOrder.openPrice - clsOrder.closePrice) * ...
                                       clsOrder.lot * obj.m_ContsTBL.ContractSize(idx);
                    % calculate close order fee
                    if (obj.m_ContsTBL.CloseFee(idx) >= 0)
                        clsfee = obj.m_ContsTBL.CloseFee(idx) * clsOrder.lot * (-1);
                    elseif (obj.m_ContsTBL.CloseFeeRate(idx) >= 0)
                        clsfee = obj.m_ContsTBL.CloseFeeRate(idx) * price * clsOrder.lot * ...
                                 obj.m_ContsTBL.ContractSize(idx) * (-1);
                    else
                        obj.m_Log.printCrucail('Warning! Trade fee or fee rate is error!');
                        flag = -7;
                        return;
                    end
                    clsOrder.fee = clsOrder.fee + clsfee;
                    % add close order into CloseBox
                    obj.m_CloseBox = [obj.m_CloseBox;clsOrder];
                    % print close order in real time
                    if obj.m_DumpClsOrdRT == EnumType.ON 
                        fid = fopen('ClsOrdRT.txt','a');
                        fprintf(fid,'%-6s %-7s %-20s  %-20s %10.2f %10.2f %4d %7.2f %10.2f\r\n', ...
                                obj.m_CloseBox(end).instID, ...
                                char(obj.m_CloseBox(end).buysell), ...
                                datestr(obj.m_CloseBox(end).openTime), ...
                                datestr(obj.m_CloseBox(end).closeTime), ...
                                obj.m_CloseBox(end).openPrice, ...
                                obj.m_CloseBox(end).closePrice, ...
                                obj.m_CloseBox(end).lot, ...
                                obj.m_CloseBox(end).fee, ...
                                obj.m_CloseBox(end).profit);
                        fclose(fid);
                    end
                    % delete order from open box
                    if obj.m_OpenBox(i).lot >= openlot
                        obj.m_OpenBox(i).lot = obj.m_OpenBox(i).lot - openlot;
                        if obj.m_OpenBox(i).lot == 0
                            obj.m_OpenBox(i).delete;
                            obj.m_OpenBox = [obj.m_OpenBox(1:i-1);obj.m_OpenBox(i+1:end)];
                            i = i - 1; % m_OpenBox delete one element
                        end
                        openlot = 0;
                    else
                        obj.m_OpenBox(i).delete;
                        obj.m_OpenBox = [obj.m_OpenBox(1:i-1);obj.m_OpenBox(i+1:end)];
                        i = i - 1;
                        % update open position lots
                        openlot = openlot - clsOrder.lot;
                    end
                    % handle capital
                    obj.m_Capital.closePosiGain = obj.m_Capital.closePosiGain + ...
                                                  clsOrder.profit; 
                    obj.m_Capital.openPosiGain = obj.m_Capital.openPosiGain - ...
                                                 clsOrder.profit;
                    obj.m_Capital.margin = abs(obj.m_Capital.margin - clsOrder.margin); 
                end
            elseif buysell == EnumType.SELL
                if obj.m_OpenBox(i).buysell == EnumType.BUY 
                    % find open order
                    clsOrder = obj.m_OpenBox(i).clone;
                    clsOrder.closePrice = price;
                    clsOrder.closeTime = closetime;
                    if clsOrder.lot >= openlot
                        clsOrder.lot = openlot;
                    end
                    % calculate close order profit
                    clsOrder.profit = (clsOrder.closePrice - clsOrder.openPrice) * ...
                                       clsOrder.lot * obj.m_ContsTBL.ContractSize(idx);
                    % calculate close order fee
                    if (obj.m_ContsTBL.CloseFee(idx) >= 0)
                        clsfee = obj.m_ContsTBL.CloseFee(idx) * clsOrder.lot * (-1);
                    elseif (obj.m_ContsTBL.CloseFeeRate(idx) >= 0)
                        clsfee = obj.m_ContsTBL.CloseFeeRate(idx) * price * clsOrder.lot * ...
                                 obj.m_ContsTBL.ContractSize(idx) * (-1);
                    else
                        obj.m_Log.printCrucail('Warning! Trade fee or fee rate is error!');
                        flag = -8;
                        return;
                    end
                    clsOrder.fee = clsOrder.fee + clsfee;
                    % add close order into CloseBox
                    obj.m_CloseBox = [obj.m_CloseBox;clsOrder];
                    % print close order in real time
                    if obj.m_DumpClsOrdRT == EnumType.ON 
                        fid = fopen('ClsOrdRT.txt','a');
                        fprintf(fid,'%-6s %-7s %-20s  %-20s %10.2f %10.2f %4d %7.2f %10.2f\r\n', ...
                                obj.m_CloseBox(end).instID, ...
                                char(obj.m_CloseBox(end).buysell), ...
                                datestr(obj.m_CloseBox(end).openTime), ...
                                datestr(obj.m_CloseBox(end).closeTime), ...
                                obj.m_CloseBox(end).openPrice, ...
                                obj.m_CloseBox(end).closePrice, ...
                                obj.m_CloseBox(end).lot, ...
                                obj.m_CloseBox(end).fee, ...
                                obj.m_CloseBox(end).profit);
                        fclose(fid);
                    end
                    % delete order from open box
                    if obj.m_OpenBox(i).lot >= openlot
                        obj.m_OpenBox(i).lot = obj.m_OpenBox(i).lot - openlot;
                        if obj.m_OpenBox(i).lot == 0
                            obj.m_OpenBox(i).delete;
                            obj.m_OpenBox = [obj.m_OpenBox(1:i-1);obj.m_OpenBox(i+1:end)];
                            i = i - 1;
                        end
                        openlot = 0;
                    else
                        obj.m_OpenBox(i).delete;
                        obj.m_OpenBox = [obj.m_OpenBox(1:i-1);obj.m_OpenBox(i+1:end)];
                        i = i - 1;
                        % update open position lots
                        openlot = openlot - clsOrder.lot;
                    end
                    % handle capital
                    obj.m_Capital.closePosiGain = obj.m_Capital.closePosiGain + ...
                                                  clsOrder.profit; 
                    obj.m_Capital.openPosiGain = obj.m_Capital.openPosiGain - ...
                                                 clsOrder.profit;
                    obj.m_Capital.margin = abs(obj.m_Capital.margin - clsOrder.margin);
                end
            end
        end
        i = i + 1;
    end
    % close position success
    if openlot == 0
        % handle position
        i = 1;
        while i <= length(obj.m_PosiBox)
            if strcmp(obj.m_PosiBox(i).instID,instID)
                if buysell == EnumType.BUY
                    if obj.m_PosiBox(i).buysell == EnumType.SELL   
                        obj.m_PosiBox(i).totalLot = obj.m_PosiBox(i).totalLot - lot;
                        obj.m_PosiBox(i).allowCloseLot = obj.m_PosiBox(i).allowCloseLot - lot;
                        if obj.m_PosiBox(i).todayLot - lot < 0
                            obj.m_PosiBox(i).todayLot = 0;
                        else
                            obj.m_PosiBox(i).todayLot = obj.m_PosiBox(i).todayLot - lot;
                        end
                        % delete position record
                        if obj.m_PosiBox(i).totalLot == 0
                            obj.m_PosiBox(i).delete;
                            obj.m_PosiBox = [obj.m_PosiBox(1:i-1);obj.m_PosiBox(i+1:end)];
                        end
                        break;
                    end
                elseif buysell == EnumType.SELL
                    if obj.m_PosiBox(i).buysell == EnumType.BUY
                        obj.m_PosiBox(i).totalLot = obj.m_PosiBox(i).totalLot - lot;
                        obj.m_PosiBox(i).allowCloseLot = obj.m_PosiBox(i).allowCloseLot - lot;
                        if obj.m_PosiBox(i).todayLot - lot < 0
                            obj.m_PosiBox(i).todayLot = 0;
                        else
                            obj.m_PosiBox(i).todayLot = obj.m_PosiBox(i).todayLot - lot;
                        end
                        if obj.m_PosiBox(i).totalLot == 0
                            obj.m_PosiBox(i).delete;
                            obj.m_PosiBox = [obj.m_PosiBox(1:i-1);obj.m_PosiBox(i+1:end)];
                        end
                        break;
                    end
                end
            end
            i = i + 1;
        end
        % calculate close position fee
        if (obj.m_ContsTBL.CloseFee(idx) >= 0)
            fee = obj.m_ContsTBL.CloseFee(idx) * lot * (-1);
        elseif (obj.m_ContsTBL.CloseFeeRate(idx) >= 0)
            fee = obj.m_ContsTBL.CloseFeeRate(idx) * price * lot * ...
                  obj.m_ContsTBL.ContractSize(idx) * (-1);
        else
            obj.m_Log.printCrucail('Warning! Trade fee or fee rate is error!');
            flag = -9;
            return;
        end
        % handle capital
        obj.m_Capital.fee = obj.m_Capital.fee + fee;
        obj.m_Capital.balance = obj.m_Capital.balance + fee;
        obj.m_Capital.freeMoney = obj.m_Capital.balance - ...
                                  obj.m_Capital.margin;
        % create close order to m_TradeBox
        clsTrdOrd = FutureOrder(instID,EnumType.CLOSE,buysell,price,lot,closetime);
        % set close trade order fee
        clsTrdOrd.fee = fee;
        obj.m_TradeBox = [obj.m_TradeBox;clsTrdOrd];
        % set success flag
        flag = 1;
        if obj.m_Debug == EnumType.ON
            obj.m_Log.printInfo('%20s %6s CLOSE %-4s %7.2f %4d', ...
                                datestr(closetime),instID,char(buysell), ...
                                price,int32(lot));
        end
    else
        flag = -10;
        obj.m_Log.printFatal('Error! Can not close %s all %d lot position.', ...
                             instID,int32(lot));
    end
end