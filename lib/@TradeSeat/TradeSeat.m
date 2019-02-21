classdef TradeSeat < handle
    properties(Access=private)
        m_Capital;
        m_PosiBox;
        m_TradeBox;
        m_CloseBox;
        m_OpenBox;
        m_EntrustBox;
        m_CapiDayBox;
        m_CapiHourBox;
        m_RiskCtrl;
        m_KPI;
        m_Log;
        m_DumpTimer;
        m_ContsTBL;
        m_Index;
        m_Debug;
        m_DumpClsOrdRT;
    end
    %
    methods(Access=private)
        dumpTimerFcn(obj,~);
    end
    %
    methods
        function obj = TradeSeat(debug,logT,contsFile)
            if nargin == 0
                obj.m_Debug = EnumType.OFF;
                obj.m_Log = LogTool;
                contsTBL = 'FutureContracts.dat';
            elseif nargin == 1
                obj.m_Debug = debug;
                obj.m_Log = LogTool;
                contsTBL = 'FutureContracts.dat';
            elseif nargin == 2
                obj.m_Debug = debug;
                obj.m_Log = logT;
                contsTBL = 'FutureContracts.dat';
            elseif nargin == 3
                obj.m_Debug = debug;
                obj.m_Log = logT;
                contsTBL = contsFile;
            else
                disp 'Error! TradePlatform constructor only accept 0/1/2/3 input parameters.'
            end
            %
            obj.m_Capital = Capital;
            obj.m_RiskCtrl = struct('liquidatePercent', 0, ...
                                    'isLiquidate', 0, ...
                                    'maxPosition', 3);
            obj.m_KPI = struct('maxFloatLoss', 0, ...
                               'maxFloatGain', 0, ...
                               'minFreeMoneyRate', 1, ...
                               'absDrawdown', 0);
            obj.m_Index = struct('trdBoxDayBeginIdx',1, ...
                                 'clsBoxDayBeginIdx',1, ...
                                 'openBoxDayBeginIdx',1);
            %
            obj.m_DumpTimer = timer;
            obj.m_DumpTimer.Name = sprintf('TrdPltDumpTimer-%s',datestr(now));
            obj.m_DumpTimer.Tag = 'TrdPltDumpTimer';
            obj.m_DumpTimer.Period = 86400;
            obj.m_DumpTimer.StartDelay = 3600;
            obj.m_DumpTimer.ExecutionMode = 'fixedRate';
            obj.m_DumpTimer.BusyMode = 'queue';
            obj.m_DumpTimer.TimerFcn = @(~,~)obj.dumpTimerFcn;
            start(obj.m_DumpTimer);
            if (exist(contsTBL,'file') == 2)
                obj.m_ContsTBL = readtable(contsTBL);
            else
                obj.m_Log.printFatal('Error! Contracts file %s is not existed.',contsTBL);
            end
            obj.m_DumpClsOrdRT = EnumType.OFF;
        end
        %
        function delete(obj)
            if isvalid(obj.m_DumpTimer)
                stop(obj.m_DumpTimer);
                delete(obj.m_DumpTimer);
            end
            %
            if isvalid(obj.m_Log)
                obj.m_Log.delete;
            end
            %
            obj.m_Capital.delete;
            obj.m_PosiBox = [];
            obj.m_TradeBox = [];
            obj.m_CloseBox = [];
            obj.m_OpenBox = [];
            obj.m_EntrustBox  = [];
            obj.m_CapiDayBox = [];
            obj.m_CapiHourBox = [];
        end
        %
        function reset(obj)
            obj.m_Capital.reset;
            obj.m_RiskCtrl = struct('liquidatePercent', 0.9, ...
                                    'isLiquidate', 0, ...
                                    'maxPosition', 3);
            obj.m_KPI = struct('maxFloatLoss', 0, ...
                               'maxFloatGain', 0, ...
                               'minFreeMoneyRate', 1, ...
                               'absDrawdown', 0);
            obj.m_Index = struct('trdBoxDayBeginIdx',1, ...
                                 'clsBoxDayBeginIdx',1, ...
                                 'openBoxDayBeginIdx',1);
            obj.m_PosiBox = [];
            obj.m_TradeBox = [];
            obj.m_CloseBox = [];
            obj.m_OpenBox = [];
            obj.m_EntrustBox = [];
            obj.m_CapiDayBox = [];
            obj.m_CapiHourBox = [];
            %
            if isvalid(obj.m_DumpTimer)
                stop(obj.m_DumpTimer);
                start(obj.m_DumpTimer);
            end
        end
        %
        function setLogObj(obj,logT)
            if isa(logT,'LogTool')
                obj.m_Log.delete;
                obj.m_Log = logT;
            else
                obj.m_Log.printFatal('TradePlatform setLogTool() error!');
            end
        end
        %
        function setDebugSwitch(obj,OnOff)
            obj.m_Debug = OnOff;
        end
        %
        function setDumpClsOrdRT(obj,OnOff)
            obj.m_DumpClsOrdRT = OnOff;
        end
        %-----------------------------------------------------------------------------------
        saveMoney(obj,cash);
        %
        isOK = withdrawMoney(obj,cash);
        %
        setRiskCtrl(obj,liquidatePercent,maxPosi);
        %
        flag = openPosition(obj,instID,buysell,price,lot,timeNum);
        %
        flag = closePosition(obj,instID,buysell,price,lot,timeNum,varargin);
        %
        sendOrder(obj,instID,openclose,buysell,price,lot,expire);
        %
        monitorOrder(obj,timeNum,instID,varargin);
        %
        settlement(obj);
        %
        snapshot(obj,instID,price);
        %
        recordCapital(obj,timeType,timeNum);
        %
        drawProfitCurve(obj);
        %
        drawCapitalCurve(obj,timeType);
        %
        dumpCapital(obj,timetype,filetype,filename,varargin);
        %
        dumpPosition(obj,filetype,filename,varargin);   
        %
        dumpTradeOrders(obj,filetype,filename,varargin);
        %
        dumpCloseOrders(obj,filetype,filename,varargin);
        %
        generateKpiReport(obj,reportFile);
        %
        generateSettleStatement(obj,filename,timeNum);
        %
        cancelAllOrders(obj);
        %
        cancelOrder(obj,ordID);
        %
        posihdl = getPosition(obj,instID,buysell);
        %
        gain = getPosiGain(obj,instID,buysell);
        %
        monitorPosition(obj,timeNum,instID,open,high,low);
        %
        initPlatform(obj,capiFile,posiFile,trdOrdFile,openOrdFile,clsOrdFile);
        %
        generateKpiReportFromFile(obj,ClsOrdFile,deposit,ReportFile);
    end
end