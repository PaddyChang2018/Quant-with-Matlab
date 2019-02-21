function saveMoney(obj,cash)
    if isnumeric(cash)
        if cash > 0
            obj.m_Capital.deposit = obj.m_Capital.deposit + cash;
            obj.m_Capital.settle = obj.m_Capital.settle + cash;
            obj.m_Capital.balance = obj.m_Capital.balance + cash;
            obj.m_Capital.freeMoney = obj.m_Capital.freeMoney + cash;
        else
            obj.m_Log.printFatal('saveMoney() Error! Input cash(%0.2f) should be positive!',cash);
        end
    else
        obj.m_Log.printFatal('saveMoney() Error! Cash should be a number!');
    end
end