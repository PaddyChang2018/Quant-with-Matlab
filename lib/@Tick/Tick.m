classdef Tick < event.EventData
    properties
        InstID;
        Time;
        MilliSecond;
        LastPrice;
        AskPrice1;
        AskVolume1;
        BidPrice1;
        BidVolume1;
        Log;
    end
    %
    methods
        function obj = Tick(logT,instID,time,millisecond,lastprice,askprice1, ...
                            askvolume1,bidprice1,bidvolume1)
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
                obj.MilliSecond = millisecond;
                obj.LastPrice = lastprice;
                obj.AskPrice1 = askprice1;
                obj.AskVolume1 = askvolume1;
                obj.BidPrice1 = bidprice1;
                obj.BidVolume1 = bidvolume1;
            end
        end
        %
        function newobj = clone(obj)
            newobj = Tick(obj.Log,obj.InstID);
            newobj.Time = obj.Time;
            newobj.MilliSecond = obj.MilliSecond;
            newobj.LastPrice = obj.LastPrice;
            newobj.AskPrice1 = obj.AskPrice1;
            newobj.AskVolume1 = obj.AskVolume1;
            newobj.BidPrice1 = obj.BidPrice1;
            newobj.BidVolume1 = obj.BidVolume1;
        end
        %
        function toString(obj)
            obj.Log.printInfo('%s %s %d %0.2f %0.2f %d %0.2f %d', ...
                              obj.InstID,char(obj.Time),obj.MilliSecond, ...
                              obj.LastPrice,obj.AskPrice1,obj.AskVolume1, ...
                              obj.BidPrice1,obj.BidVolume1);
        end
    end
end