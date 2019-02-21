classdef Capital < handle
    properties
        deposit;
        settle;
        balance;
        margin;
        freeMoney;
        closePosiGain;
        openPosiGain;
        fee;
    end
    %
    methods
        function obj = Capital(deposit)
            if nargin == 0
                obj.deposit = 0;
                obj.settle = 0;
                obj.balance = 0;
                obj.margin = 0;
                obj.freeMoney = 0;
                obj.closePosiGain = 0;
                obj.openPosiGain = 0;
                obj.fee = 0;
            elseif nargin == 1
                obj.deposit = deposit;
                obj.settle = deposit;
                obj.balance = deposit;
                obj.margin = 0;
                obj.freeMoney = deposit;
                obj.closePosiGain = 0;
                obj.openPosiGain = 0;
                obj.fee = 0;
            end
        end
        %
        function reset(obj)
            obj.deposit = 0;
            obj.settle = 0;
            obj.balance = 0;
            obj.margin = 0;
            obj.freeMoney = 0;
            obj.closePosiGain = 0;
            obj.openPosiGain = 0;
            obj.fee = 0;
        end
        %
        function newobj = clone(obj)
            newobj = Capital;
            newobj.deposit = obj.deposit;
            newobj.settle = obj.settle;
            newobj.balance = obj.balance;
            newobj.margin = obj.margin;
            newobj.freeMoney = obj.freeMoney;
            newobj.closePosiGain = obj.closePosiGain;
            newobj.openPosiGain = obj.openPosiGain;
            newobj.fee = obj.fee;
        end
    end
end
