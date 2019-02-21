classdef TechAnalysis < handle
    properties(Hidden)
        m_TrendInfo;
        m_Log;
        m_Debug;
    end
    %
    methods(Hidden)
        function obj = TechAnalysis(log,debug)
            if nargin == 0
                obj.m_Log = LogTool;
                obj.m_Debug = EnumType.OFF;
            elseif nargin == 1
                obj.m_Log = log;
                obj.m_Debug = EnumType.OFF;
            elseif nargin == 2
                obj.m_Log = log;
                obj.m_Debug = debug;
            end
            obj.m_TrendInfo = struct('TrendFlag',EnumType.NONE, ...
                                     'HighPrice',0, ...
                                     'LowPrice',0, ...
                                     'StartTime',0, ...
                                     'EndTime', 0);
        end
        %
        judgeTrend(obj,bs);
        %
        findTrend(obj,bs);
    end
end