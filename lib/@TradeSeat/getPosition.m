function posihdl = getPosition(obj,instID,buysell)
    posihdl = EnumType.NONE;
    if nargin == 1
        posihdl = obj.m_PosiBox;
    elseif nargin == 3
        i = 1;
        while i <= length(obj.m_PosiBox)
            if strcmp(obj.m_PosiBox(i).instID,instID) && ...
                           (obj.m_PosiBox(i).buysell == buysell)
                posihdl = obj.m_PosiBox(i);
                return;
            end
            i = i + 1;
        end
    else
        obj.m_Log.printCrucial('Error! getPosition() only accept 0/2 input arguments.');
        return;
    end
end