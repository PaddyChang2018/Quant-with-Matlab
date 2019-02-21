classdef SimBench < handle
    properties(Hidden)
        m_TickSet;
        m_DrvTick;
        m_BarSet;
        m_DrvBar;
        m_InstSet;
        m_StartTime;
        m_EndTime;
        m_DrvType;
        m_DrvFreq;
        m_DrvInst;
        m_RefClock;
        m_RootPath;
        m_Debug;
        m_Log;
        m_TrdSeat;
    end
    %
    events
        e_OnBar;
        e_OnTick;
        e_SimInit;
        e_SimExit;
    end
    %
    methods
        function obj = SimBench(debug,logT)
            if nargin == 0
                obj.m_Debug = EnumType.OFF;
                obj.m_Log = LogTool;
            elseif nargin == 1
                obj.m_Debug = debug;
                obj.m_Log = LogTool;
            elseif nargin == 2
                obj.m_Debug = debug;
                obj.m_Log = logT;
            end
            %
            obj.m_TrdSeat = TradeSeat(obj.m_Debug,obj.m_Log);
            obj.m_StartTime = now;
            obj.m_EndTime = now;
            obj.m_DrvFreq = 1;
            obj.m_DrvInst = '';
            obj.m_RootPath = 'D:\Quant\';
        end
        %
        function delete(obj)
            for i = 1 : length(obj.m_BarSet)
                obj.m_BarSet(i).delete;
            end
            obj.m_BarSet = [];
            for i = 1 : length(obj.m_TickSet)
                obj.m_TickSet(i).delete;
            end
            obj.m_TickSet = [];
            obj.m_TrdSeat.delete;
        end
        %
        function reset(obj)
            for i = 1 : length(obj.m_BarSet)
                obj.m_BarSet(i).delete;
            end
            obj.m_BarSet = [];
            for i = 1 : length(obj.m_TickSet)
                obj.m_TickSet(i).delete;
            end
            obj.m_TickSet = [];
            obj.m_DrvBar = [];
            obj.m_DrvTick = [];
            obj.m_StartTime = now;
            obj.m_EndTime = now; 
            obj.m_DrvFreq = 1;
            obj.m_DrvInst = '';
            obj.m_TrdSeat.reset;
        end
        %
        function registerEvent(obj,EventName,CallBackFcn)
            addlistener(obj,EventName,CallBackFcn);
        end
        %
        function setTaskTime(obj,timeStr)
            obj.m_TaskTime = datenum(timeStr,'HH:MM:SS');
        end
        %
        function setMarketTime(obj,opentimeStr,closetimeStr)
            obj.m_OpenMktTime = datenum(opentimeStr,'HH:MM:SS');
            obj.m_CloseMktTime = datenum(closetimeStr,'HH:MM:SS');
        end
        %
        function setSimDrvMode(obj,instID,type,freq)
            obj.m_DrvInst = instID;
            obj.m_DrvType = type;
            obj.m_DrvFreq = freq; 
        end
        %
        function bookInstrument(obj,varargin)
            for i = 1 : length(varargin)
                obj.m_InstSet = [obj.m_InstSet;varargin{i}];
            end
        end
        %
        isOK = bookBarSeries(obj,instID,timeframe);
        isOK = bookTrdInstID(obj,varargin);
        bstbl = getBSTblVal(obj,instID,timeframe,len);
        bsobj = getBarSeries(obj,instID,timeframe,len);
        vec = getFieldOfBS(obj,instID,timeframe,field,len);
        flag = startSimulate(obj,startTime,endTime);
        exportResults(obj);
        alignTime(obj,timeNum);
        bar = getLastBar(obj,instID,timeframe);
        clearPosition(obj,time);
        price = getLastPrice(obj,instID);
        tick = getLastTick(obj);
    end
end