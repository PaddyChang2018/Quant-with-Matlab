function fillData(obj,varargin)
    if length(varargin) == 1
        if istable(varargin{1})
            obj.Time = varargin{1}.Time;
            obj.Open = varargin{1}.Open;
            obj.High = varargin{1}.High;
            obj.Low = varargin{1}.Low;
            obj.Close = varargin{1}.Close;
            obj.Volume = varargin{1}.Volume;
            obj.OpenInterest = varargin{1}.OpenInterest;
            obj.Settlement = varargin{1}.Settlement;
        else
            obj.Log.printCrucial('Error! BarSeries.fillData() input argument is not table type.');
        end
    elseif length(varargin) == 8
        obj.Time = varargin{1};
        obj.Open = varargin{2};
        obj.High = varargin{3};
        obj.Low = varargin{4};
        obj.Close = varargin{5};
        obj.Volume = varargin{6};
        obj.OpenInterest = varargin{7};
        obj.Settlement = varargin{8};
    else
        obj.Log.printCrucail('Error! BarSeries.fillData() only accept 1/8 input arguments.');
    end
end