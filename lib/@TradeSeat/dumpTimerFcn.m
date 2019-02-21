function dumpTimerFcn(obj,~)
    % dump trade order records
    if size(obj.m_TradeBox,1) > 1000
        if isunix
            dumpNum = obj.dumpTradeOrders('txt','AutoDumpHistoryOrders.xlsx');
        else
            dumpNum = obj.dumpTradeOrders('excel','AutoDumpHistoryOrders.xlsx');
        end
        %
        if dumpNum > 0
            if  size(obj.m_TradeBox,1) > dumpNum
                obj.m_TradeBox = obj.m_TradeBox(dumpNum+1:end);
            else
                obj.m_TradeBox = [];
            end
        end
    end
    % dump close order records
    if size(obj.m_CloseBox,1) > 1000
        if isunix
            dumpNum = obj.dumpCloseOrders('txt','AutoDumpHistoryOrders.xlsx');
        else
            dumpNum = obj.dumpCloseOrders('excel','AutoDumpHistoryOrders.xlsx');
        end
        %
        if dumpNum > 0
            if  size(obj.m_CloseBox,1) > dumpNum
                obj.m_CloseBox = obj.m_CloseBox(dumpNum+1:end);
            else
                obj.m_CloseBox = [];
            end
        end
    end
end