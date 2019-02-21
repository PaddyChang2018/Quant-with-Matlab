classdef LogTool < handle
    properties(SetAccess=private)
        fid;
        logName;
        logLevel;
    end
    %
    properties(Access=private)
        strEnd;
    end
    %
    methods
        function obj = LogTool(filename)
            obj.logLevel = 3;
            %
            if nargin == 0
                obj.fid = 1;
                obj.logName = '';
                obj.strEnd = '\n';
            elseif nargin == 1
                obj.fid = fopen(filename,'a');
                if obj.fid < 0
                    obj.fid = 1;
                    obj.logName = '';
                    obj.strEnd = '\n';
                    disp 'LogTool constructor function can not open log file!';
                    return;
                end
                obj.logName = filename;
                obj.strEnd = '\r\n';
                fprintf(obj.fid,'Log is recorded at %s.\r\n',datestr(now));
            else
                error 'LogTool constructor function parameter error!\n';
            end
        end
        %
        function delete(obj)
            if obj.fid >= 3
                fprintf(obj.fid,'Log is closed at %s.\r\n',datestr(now));
                fclose(obj.fid);
            end
        end
        %
        function setLogPath(obj,filename)
            if obj.fid >= 3
                fclose(obj.fid);
            end
            if nargin == 1
                obj.fid = 1;
                obj.logName = '';
                obj.strEnd = '\n';
            elseif nargin == 2
                obj.fid = fopen(filename,'a');
                if obj.fid < 0
                    obj.fid = 1;
                    obj.filename = '';
                    disp 'LogTool.setLogPath() can not open log file!';
                    return;
                end
                obj.logName = filename;
                obj.strEnd = '\r\n';
                fprintf(obj.fid,'Log is recorded at %s.\r\n',datestr(now));
            else
                error 'LogTool.setLogPath() parameter error!';
            end
        end
        %
        function setLogLevel(obj,level)
            if level >= 1
                obj.logLevel = level;
            else
                disp 'LogTool.setLogLevel() parameter error!';
            end
        end
        %
        function printInfo(obj,formatSpec,varargin)
            if obj.logLevel >= 3
                format = strcat(formatSpec,obj.strEnd);
                fprintf(obj.fid,format,varargin{:});
            end
        end
        %
        function printCrucial(obj,formatSpec,varargin)
            if obj.logLevel >= 2
                format = strcat(formatSpec,obj.strEnd);
                fprintf(obj.fid,format,varargin{:});
            end
        end
        %
        function printFatal(obj,formatSpec,varargin)
            format = strcat(formatSpec,obj.strEnd);
            fprintf(obj.fid,format,varargin{:});
        end
    end
end