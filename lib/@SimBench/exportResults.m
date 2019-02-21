function exportResults(obj)
    obj.m_TrdSeat.dumpCapital(EnumType.NOW,EnumType.STDIO);
    obj.m_TrdSeat.dumpPosition(EnumType.STDIO);
    % obj.m_TrdSeat.dumpCapital(EnumType.DAY,EnumType.STDIO);
    % obj.m_TrdSeat.dumpTradeOrders(EnumType.STDIO);
    obj.m_TrdSeat.dumpCloseOrders(EnumType.STDIO);
    obj.m_TrdSeat.dumpCloseOrders(EnumType.TXT);
    obj.m_TrdSeat.drawProfitCurve
    obj.m_TrdSeat.drawCapitalCurve(EnumType.DAY);
    obj.m_TrdSeat.drawCapitalCurve(EnumType.HOUR);
    obj.m_TrdSeat.generateKpiReport;
end