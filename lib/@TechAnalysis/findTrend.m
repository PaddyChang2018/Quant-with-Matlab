function findTrend(obj,bs)
    %------------------------------------------------------------------------
    % reset trend flag to none
    %------------------------------------------------------------------------
    obj.m_TrendInfo.TrendFlag = EnumType.NONE;
    %
    for i = 10:length(bs.Time)
        obj.judgeTrend(bs.clone(i-9,i));
    end
end