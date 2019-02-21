classdef TickSeries < handle
    properties
        InstID;
        TimeFrame;
        Iterator;
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
        function obj = TickSeries(instid,logT,varargin)
            if nargin == 1
                obj.InstID = instid;
                obj.Log = LogTool;
            elseif nargin >= 2
                obj.InstID = instid;
                obj.Log = logT;
            end
            %
            if ~isempty(varargin)
                if length(varargin) == 1
                    if istable(varargin{1})
                        obj.Time = varargin{1}.Time;
                        obj.MilliSecond = varargin{1}.MilliSecond;
                        obj.LastPrice = varargin{1}.LastPrice;
                        obj.AskPrice1 = varargin{1}.AskPrice1;
                        obj.AskVolume1 = varargin{1}.AskVolume1;
                        obj.BidPrice1 = varargin{1}.BidPrice1;
                        obj.BidVolume1 = varargin{1}.BidVolume1;
                    else
                        obj.Log.printFatal('Error! TickSeries input argument is not table type.');
                        obj.delete;
                        return;
                    end
                elseif length(varargin) == 7
                    obj.Time = varargin{1};
                    obj.MilliSecond = varargin{2};
                    obj.LastPrice = varargin{3};
                    obj.AskPrice1 = varargin{4};
                    obj.AskVolume1 = varargin{5};
                    obj.BidPrice1 = varargin{6};
                    obj.BidVolume1 = varargin{7};
                else
                    obj.Log.printFatal('Error! TickSeries Constructor only accept 1/2/3/7 input arguments.');
                    obj.delete;
                    return;
                end
                if ~isdatetime(obj.Time(1))
                    obj.Time = datetime(obj.Time,'InputFormat','yyyy-MM-dd HH:mm:ss');
                end
            end
            %
            obj.TimeFrame = EnumType.TICK;
            obj.Iterator = 1;
        end
        %
        function tbl = toTable(obj)
            tbl = table(obj.Time,obj.MilliSecond,obj.LastPrice,obj.AskPrice1, ...
                        obj.AskVolume1,obj.BidPrice1,obj.BidVolume1,'VariableNames', ...
                        {'Time','MilliSecond','LastPrice','AskPrice1', ...
                         'AskVolume1','BidPrice1','BidVolume1'});
        end
        %
        importData(obj,varargin);
        %
        newobj = clone(obj,varargin);
    end
end