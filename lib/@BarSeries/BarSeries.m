classdef BarSeries < handle
    properties
        InstID;
        TimeFrame;
        Iterator;
        Time;
        Open;
        High;
        Low;
        Close;
        Volume;
        OpenInterest;
        Settlement;
        Log;
    end
    %
    methods
        function obj = BarSeries(instid,timeframe,logT,varargin)
            if nargin == 2
                obj.InstID = instid;
                obj.TimeFrame = timeframe;
                obj.Log = LogTool;
            elseif nargin >= 3
                obj.InstID = instid;
                obj.TimeFrame = timeframe;
                obj.Log = logT;
            end
            %
            if ~isempty(varargin)
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
                        obj.Log.printFatal('Error! BarSeries input argument is not table type.');
                        obj.delete;
                        return;
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
                    obj.Log.printFatal('Error! BarSeries Constructor only accept 2/3/4/10 input arguments.');
                    obj.delete;
                    return;
                end
            end
            %
            obj.Iterator = 1;
        end
        %
        function tbl = toTable(obj)
            tbl = table(obj.Time,obj.Open,obj.High,obj.Low,obj.Close,obj.Volume, ...
                        obj.OpenInterest,obj.Settlement,'VariableNames', ...
                        {'Time','Open','High','Low','Close','Volume','OpenInterest','Settlement'});
        end
        %
        fillData(obj,varargin);
        %
        newobj = clone(obj,varargin);
        %
        drawCandle(obj);
    end
end