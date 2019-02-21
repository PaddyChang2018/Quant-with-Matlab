function newobj = clone(obj,varargin)
    newobj = TickSeries(obj.InstID,obj.Log);
    newobj.TimeFrame = EnumType.TICK;
    if isempty(varargin)
        newobj.Time = obj.Time;
        newobj.MilliSecond = obj.MilliSecond;
        newobj.LastPrice = obj.LastPrice;
        newobj.AskPrice1 = obj.AskPrice1;
        newobj.BidPrice1 = obj.BidPrice1;
    elseif length(varargin) == 1
        % only length, [iterator - length + 1 : iterator]
        if obj.Iterator >= varargin{1}
            si = obj.Iterator - varargin{1} + 1;
            ei = obj.Iterator;
            newobj.Time = obj.Time(si:ei);
            newobj.MilliSecond = obj.MilliSecond(si:ei);
            newobj.LastPrice = obj.LastPrice(si:ei);
            newobj.AskPrice1 = obj.AskPrice1(si:ei);
            newobj.BidPrice1 = obj.BidPrice1(si:ei);
        else
            obj.Log.printFatal('Error! TickSeries.clone() get %s %s series length(%d) is longer than iterator(%d).', ...
                               obj.InstID,char(obj.TimeFrame),varargin{1},obj.Iterator);
        end
    elseif length(varargin) == 2
        if (varargin{1} <= varargin{2}) && (varargin{2} <= length(obj.LastPrice))
            newobj.Time = obj.Time(varargin{1}:varargin{2});
            newobj.MilliSecond = obj.MilliSecond(varargin{1}:varargin{2});
            newobj.LastPrice = obj.LastPrice(varargin{1}:varargin{2});
            newobj.AskPrice1 = obj.AskPrice1(varargin{1}:varargin{2});
            newobj.BidPrice1 = obj.BidPrice1(varargin{1}:varargin{2});
        end
    else
        obj.Log.printFatal('Error! TickSeries.clone() only accept 0/1/2 input arguments.');
    end
end