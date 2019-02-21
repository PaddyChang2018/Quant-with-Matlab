classdef Bar < event.EventData 
    properties
        InstID;
        Time;
        Open;
        High;
        Low;
        Close;
        Volume;
        Turnover;
        Log;
    end
    %
    methods
        function obj = Bar(logT,instID,time,open,high,low,close,volume,turnover)
            if nargin == 0
                obj.Log = LogTool;
            elseif nargin == 1
                obj.Log = logT;
            elseif nargin == 2
                obj.Log = logT;
                obj.InstID = instID;
            elseif nargin == 9
                obj.Log = logT;
                obj.InstID = instID;
                obj.Time = time;
                obj.Open = open;
                obj.High = high;
                obj.Low = low;
                obj.Close = close;
                obj.Volume = volume;
                obj.Turnover = turnover;
            else
                obj.Log.printCrucial('Error! Bar constructor only accept 0/1/2/9 input arguments.');
            end
        end
        %
        function toString(obj)
            obj.Log.printInfo('%s %s %0.2f %0.2f %0.2f %0.2f %d %0.2f', ...
                              obj.InstID,datestr(obj.Time),obj.Open,obj.High, ...
                              obj.Low,obj.Close,obj.Volume,obj.Turnover);
        end
        %
        function newobj = clone(obj)
            newobj = Bar(obj.Log);
            newobj.InstID = obj.InstID;
            newobj.Time = obj.Time;
            newobj.Open = obj.Open;
            newobj.High = obj.High;
            newobj.Low = obj.Low;
            newobj.Close = obj.Close;
            newobj.Volume = obj.Volume;
            newobj.Turnover = obj.Turnover;
        end
    end
end