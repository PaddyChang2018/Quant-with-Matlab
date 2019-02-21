classdef FutureOrder < handle
    properties
        instID;
        openclose;
        buysell;
        openPrice;
        lot;
        openTime;
        enTrust;
        expire;
        closePrice;
        closeTime;
        margin;
        profit;
        mark;
        id;
        fee;
    end
    %
    methods
        function obj = FutureOrder(instID,openclose,buysell,openPrice,lot, ...
                                   openTime,enTrust,expire)
            if nargin == 0 
            elseif nargin == 6
                obj.instID = instID;
                obj.openclose = openclose;
                obj.buysell = buysell;
                obj.openPrice = openPrice;
                obj.lot = lot;
                obj.openTime = openTime;
                obj.enTrust = 0;
                obj.expire = EnumType.NONE;
            elseif nargin == 8
                obj.instID = instID;
                obj.openclose = openclose;
                obj.buysell = buysell;
                obj.openPrice = openPrice;
                obj.lot = lot;
                obj.openTime = openTime;
                obj.enTrust = enTrust;
                obj.expire = expire;
            end
            %
            obj.closePrice = 0;
            obj.closeTime = datenum('01-Jan-1970','dd-mmm-yyyy');
            obj.margin = 0;
            obj.profit = 0;
            obj.mark = EnumType.NONE;
            obj.id = EnumType.NONE;
            obj.fee = 0;
        end
        %
        function newobj = clone(obj)
            newobj = FutureOrder;
            newobj.instID = obj.instID;
            newobj.openclose = obj.openclose;
            newobj.buysell = obj.buysell;
            newobj.openPrice = obj.openPrice;
            newobj.lot = obj.lot;
            newobj.openTime = obj.openTime;
            newobj.enTrust = obj.enTrust;
            newobj.expire = obj.expire;
            newobj.closePrice = obj.closePrice;
            newobj.closeTime = obj.closeTime;
            newobj.margin = obj.margin;
            newobj.profit = obj.profit;
            newobj.mark = obj.mark;
            newobj.id = obj.id;
            newobj.fee = obj.fee;
        end
    end
end