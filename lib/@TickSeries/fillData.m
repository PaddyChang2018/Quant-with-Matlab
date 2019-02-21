function fillData(obj,varargin)
    if length(varargin) == 1
        if istable(varargin{1})
            obj.Time = varargin{1}.Time;
            obj.MilliSecond = varargin{1}.MilliSecond;
            obj.LastPrice = varargin{1}.LastPrice;
            obj.AskPrice1 = varargin{1}.AskPrice1;
            obj.BidPrice1 = varargin{1}.BidPrice1; 
        else
            obj.Log.printCrucial('Error! TickSeries.fillData() input argument is not table type.');
        end
    elseif length(varargin) == 5
        obj.Time = varargin{1};
        obj.MilliSecond = varargin{2};
        obj.LastPrice = varargin{3};
        obj.AskPrice1 = varargin{4};
        obj.BidPrice1 = varargin{5};
    else
        obj.Log.printCrucail('Error! TickSeries.fillData() only accept 1/5 input arguments.');
    end
end