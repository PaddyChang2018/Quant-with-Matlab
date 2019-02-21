function monitorOrder(obj,timeNum,instID,varargin)
    %---------------------------------------------------------------------------
    % judge entrust order box whether is empty or not
    %---------------------------------------------------------------------------
    if isempty(obj.m_EntrustBox)
        return;
    end 
    %
    if length(varargin) == 1
        lastprice = varargin{1};
        i = 1;
        while i <= length(obj.m_EntrustBox)
            if strcmp(obj.m_EntrustBox(i).instID,instID)
                trigger = -1;
                if (obj.m_EntrustBox(i).buysell == EnumType.BUY)
                    if (obj.m_EntrustBox(i).openPrice >= lastprice)
                        trigger = 1;
                    end
                elseif (obj.m_EntrustBox(i).buysell == EnumType.SELL) 
                    if (obj.m_EntrustBox(i).openPrice <= lastprice)
                        trigger = 1;
                    end
                else
                    obj.m_Log.printCrucial('Error! Can not recognize entrust order buy/sell flag : %s.', ...
                                           char(obj.m_EntrustBox(i).buysell));
                end
                %
                if trigger == 1
                    flag = -1;
                    if obj.m_EntrustBox(i).openclose == EnumType.OPEN
                        % entrust to open trade
                        flag = obj.openPosition(obj.m_EntrustBox(i).instID, ...
                                                obj.m_EntrustBox(i).buysell, ...
                                                lastprice, ...
                                                obj.m_EntrustBox(i).lot, ...
                                                timeNum);
                    elseif obj.m_EntrustBox(i).openclose == EnumType.CLOSE
                        % entrust to close trade
                        flag = obj.closePosition(obj.m_EntrustBox(i).instID, ...
                                                 obj.m_EntrustBox(i).buysell, ...
                                                 lastprice, ...
                                                 obj.m_EntrustBox(i).lot, ...
                                                 timeNum, ...
                                                 obj.m_EntrustBox(i).expire);
                    else
                        obj.m_Log.printCrucial('Error! Can not recognize entrust order open/close flag : %s.', ...
                                               char(obj.m_EntrustBox(i).openclose));
                    end
                    %
                    if (flag == 1)
                        % delete j entrust order
                        obj.m_EntrustBox(i).delete;
                        obj.m_EntrustBox = [obj.m_EntrustBox(1:i-1);obj.m_EntrustBox(i+1:end)];
                        i = i - 1;
                    end
                end
            end
            i = i + 1;
        end
    elseif length(varargin) == 2
        high = varargin{1};
        low = varargin{2};
        i = 1;
        while i <= length(obj.m_EntrustBox)
            if strcmp(obj.m_EntrustBox(i).instID,instID)
                if (obj.m_EntrustBox(i).openPrice >= low) && ...
                   (obj.m_EntrustBox(i).openPrice <= high)
                    flag = -1;
                    if obj.m_EntrustBox(i).openclose == EnumType.OPEN
                        % entrust to open trade
                        flag = obj.openPosition(obj.m_EntrustBox(i).instID, ...
                                                obj.m_EntrustBox(i).buysell, ...
                                                obj.m_EntrustBox(i).openPrice, ...
                                                obj.m_EntrustBox(i).lot, ...
                                                timeNum);
                    elseif obj.m_EntrustBox(i).openclose == EnumType.CLOSE
                        % entrust to close trade
                        flag = obj.closePosition(obj.m_EntrustBox(i).instID, ...
                                                 obj.m_EntrustBox(i).buysell, ...
                                                 obj.m_EntrustBox(i).openPrice, ...
                                                 obj.m_EntrustBox(i).lot, ...
                                                 timeNum, ...
                                                 obj.m_EntrustBox(i).expire);
                    else
                        obj.m_Log.printCrucial('Error! Can not recognize entrust order open/close flag : %s.', ...
                                               char(obj.m_EntrustBox(i).openclose));
                    end
                    %
                    if (flag == 1)
                        % delete j entrust order
                        obj.m_EntrustBox(i).delete;
                        obj.m_EntrustBox = [obj.m_EntrustBox(1:i-1);obj.m_EntrustBox(i+1:end)];
                        i = i - 1;
                    end
                end
            end
            i = i + 1;
        end
    else
        obj.m_Log.printFatal('Error! monitorOrder only accept 3/4 input arguments.');
    end
end