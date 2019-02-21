classdef DatabaseSrc < handle
    properties(Access=private)
        conn;
        curs;
    end
    %
    properties
        instance;
        username;
        password;
        vendor;
        servAddr;
    end
    %
    methods
        function obj = DatabaseSrc(instance,username,password,vendor,servAddr)
            obj.instance = instance;
            obj.username = username;
            obj.password = password;
            obj.vendor   = vendor;
            obj.servAddr = servAddr;   
        end
        %
        function isOK = connect(obj)
            obj.conn = database(obj.instance,obj.username,obj.password, ...
                                'Vendor',obj.vendor,'Server',obj.servAddr);
            if isconnection(obj.conn)
                isOK = 1;
            else
                isOK = 0;
            end
        end
        %
        function disconnect(obj)
            if ~isempty(obj.curs)
                close(obj.curs);
            end
            if ~isempty(obj.conn)
                close(obj.conn);
            end
        end
        %
        function delete(obj)
            if ~isempty(obj.curs)
                close(obj.curs);
            end
            if ~isempty(obj.conn)
                close(obj.conn);
            end
        end
        %
        function dataTbl = getTableData(obj,sql)
            obj.curs = exec(obj.conn,sql);
            obj.curs = fetch(obj.curs);
            ats = attr(obj.curs);
            dataTbl = cell2table(obj.curs.Data, 'VariableNames', {ats.fieldName});
        end
        %
        function dataMat = getMatData(obj,sql)
            tmp = fetch(obj.conn,sql);
            dataMat = cell2mat(tmp);
        end
    end
end