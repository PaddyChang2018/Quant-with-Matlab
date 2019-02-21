function newobj = clone(obj,varargin)
    newobj = BarSeries(obj.InstID,obj.TimeFrame,obj.Log);
    if isempty(varargin)
        newobj.Time = obj.Time;
        newobj.Open = obj.Open;
        newobj.High = obj.High;
        newobj.Low = obj.Low;
        newobj.Close = obj.Close;
        newobj.Volume = obj.Volume;
        newobj.OpenInterest = obj.OpenInterest;
        newobj.Settlement = obj.Settlement;
    elseif length(varargin) == 1
        % only length, [iterator - length + 1 : iterator]
        if obj.Iterator >= varargin{1}
            si = obj.Iterator - varargin{1} + 1;
            ei = obj.Iterator;
            newobj.Time = obj.Time(si:ei);
            newobj.Open = obj.Open(si:ei);
            newobj.High = obj.High(si:ei);
            newobj.Low = obj.Low(si:ei);
            newobj.Close = obj.Close(si:ei);
            newobj.Volume = obj.Volume(si:ei);
            newobj.OpenInterest = obj.OpenInterest(si:ei);
            newobj.Settlement = obj.Settlement(si:ei);
        else
            obj.Log.printFatal('Error! BarSeries.clone() get %s %s bar series length(%d) is longer than iterator(%d).', ...
                               obj.InstID,char(obj.TimeFrame),varargin{1},obj.Iterator);
        end
    elseif length(varargin) == 2
        if (varargin{1} <= varargin{2}) && (varargin{2} <= length(obj.Time))
            newobj.Time = obj.Time(varargin{1}:varargin{2});
            newobj.Open = obj.Open(varargin{1}:varargin{2});
            newobj.High = obj.High(varargin{1}:varargin{2});
            newobj.Low = obj.Low(varargin{1}:varargin{2});
            newobj.Close = obj.Close(varargin{1}:varargin{2});
            newobj.Volume = obj.Volume(varargin{1}:varargin{2});
            newobj.OpenInterest = obj.OpenInterest(varargin{1}:varargin{2});
            newobj.Settlement = obj.Settlement{varargin{1}:varargin{2}};
        end
    else
        obj.Log.printFatal('Error! BarSeries.clone() only accept 0/1/2 input arguments.');
    end
end