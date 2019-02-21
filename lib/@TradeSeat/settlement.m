function settlement(obj)
    % settle capital
    obj.m_Capital.settle = obj.m_Capital.balance - obj.m_Capital.openPosiGain;
    obj.m_Capital.fee = 0;
    obj.m_Capital.closePosiGain = 0;
    % settle position
    for i = 1 : length(obj.m_PosiBox)
        obj.m_PosiBox(i).todayLot = 0;
    end
    % clear entrust orders
    for i = 1:length(obj.m_EntrustBox)
        obj.m_EntrustBox(i).delete;
    end
    obj.m_EntrustBox = [];
    % set day begin index
    obj.m_Index.trdBoxDayBeginIdx = length(obj.m_TradeBox) + 1;
    obj.m_Index.clsBoxDayBeginIdx = length(obj.m_CloseBox) + 1;
    obj.m_Index.openBoxDayBeginIdx = length(obj.m_OpenBox) + 1;
end