function isOK = withdrawMoney(obj,cash)
    isOK = 0;
    if isnumeric(cash)
        if cash > 0
            if cash <= obj.m_Capital.freeMoney
                obj.m_Capital.balance = obj.m_Capital.balance - cash;
                obj.m_Capital.deposit = obj.m_Capital.deposit - cash;
                obj.m_Capital.freeMoney = obj.m_Capital.freeMoney - cash;
                isOK = 1;
            else
                obj.m_Log.printCrucial('withdrawMoney() can not withdraw %0.2f cash.',cash);
            end
        else
            obj.m_Log.printCrucial('withdrawMoney() Error! Withdraw cash(%0.2f) should be positive!',cash);
        end
    else
        obj.m_Log.printFatal('withdrawMoney() Error! Cash should be a number!');
    end
end