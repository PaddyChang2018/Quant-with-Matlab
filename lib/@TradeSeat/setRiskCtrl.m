function setRiskCtrl(obj,liquidatePercent,maxPosi)
    if nargin == 2
        if liquidatePercent > 0 && liquidatePercent < 1
            obj.m_RiskCtrl.liquidatePercent = liquidatePercent;
        else
            obj.m_Log.printCrucial('setRiskCtrl() liquidatePercent should be 0~1.');
        end
    elseif nargin == 3
        if liquidatePercent > 0 && liquidatePercent < 1
            obj.m_RiskCtrl.liquidatePercent = liquidatePercent;
        else
            obj.m_Log.printCrucial('setRiskCtrl() liquidatePercent should be 0~1.');
        end
        obj.m_RiskCtrl.maxPosition = maxPosi;
    else
        obj.m_Log.printCrucial('setRiskCtrl() input parameter number error!');
    end
end