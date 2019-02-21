function gain = getPosiGain(obj,instID,buysell)
    gain = -Inf;
    len = length(obj.m_PosiBox);
    if len == 0 
        return;
    end
    if nargin == 1
        gain = 0;
        for i = 1 : len
            gain = gain + obj.m_PosiBox(i).profit;
        end
    elseif nargin == 3
        for i = 1 :len 
            if strcmp(obj.m_PosiBox(i).instID,instID) && ...
                           (obj.m_PosiBox(i).buysell == buysell)
                gain = obj.m_PosiBox(i).profit;
                return;
            end
        end
    else
        obj.m_Log.printCrucial('Error! getPosiGain() only accept 0/2 input arguments.');
        return;
    end
end