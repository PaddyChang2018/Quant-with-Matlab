classdef FuturePosition < handle
    properties
        instID;
        buysell;
        totalLot;
        todayLot;
        allowCloseLot;
        avgPrice;
        margin;
        profit;
    end
    %
    methods
        function obj = FuturePosition(instID,buysell,lot,price,margin)
            if nargin == 0
            elseif nargin == 5
                obj.instID = instID;
                obj.buysell = buysell;
                obj.totalLot = lot;
                obj.todayLot = lot;
                obj.allowCloseLot = lot;
                obj.avgPrice = price;
                obj.margin = margin;
                obj.profit = 0;
            end
        end
        %
        function newobj = clone(obj)
            newobj = FuturePosition;
            newobj.instID = obj.instID;
            newobj.buysell = obj.buysell;
            newobj.totalLot = obj.totalLot;
            newobj.todayLot = obj.todayLot;
            newobj.allowCloseLot = obj.allowCloseLot;
            newobj.avgPrice = obj.avgPrice;
            newobj.margin = obj.margin;
            newobj.profit = obj.profit;
        end
    end
end