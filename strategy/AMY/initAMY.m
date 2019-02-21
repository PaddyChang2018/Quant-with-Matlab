% function initAMY(sim,~)
function initAMY()
%     % book 5 minute bar series
%     if EnumType.FALSE == sim.bookBarSeries('a1701',EnumType.M5)
%         log.printFatal('Error! simApple() can not book a1701 M5 bar series.');
%         sim.delete;
%         return;
%     end
%     if EnumType.FALSE == sim.bookBarSeries('m1701',EnumType.M5)
%         log.printFatal('Error! simApple() can not book m1701 M5 bar series.');
%         sim.delete;
%         return;
%     end
%     if EnumType.FALSE == sim.bookBarSeries('y1701',EnumType.M5)
%         log.printFatal('Error! simApple() can not book y1701 M5 bar series.');
%         sim.delete;
%         return;
%     end
%     % book trade instrument
%     if EnumType.FALSE == sim.bookTrdInstID('a1701')
%         log.printFatal('Error! simApple() can not book a1701 trade instument.');
%         sim.delete;
%         return;
%     end
%     if EnumType.FALSE == sim.bookTrdInstID('m1701')
%         log.printFatal('Error! simApple() can not book m1701 trade instument.');
%         sim.delete;
%         return;
%     end
%     if EnumType.FALSE == sim.bookTrdInstID('y1701')
%         log.printFatal('Error! simApple() can not book y1701 trade instument.');
%         sim.delete;
%         return;
%     end
%     % set simulate drive instrument and timeframe
%     if EnumType.FALSE == sim.setSimDrvMode('y1701',EnumType.M1)
%         log.printFatal('Error! setSimDrvMode failed.');
%         sim.delete;
%         return;
%     end
    % init a global state struct
    global g_LastState;
    global g_TP;
    g_LastState = struct('isArbi', EnumType.FALSE, ...
                         'Pair', 0, ...
                         'LeftDir', 0, ...
                         'DA', 0, ...
                         'DM', 0, ...
                         'DY', 0);
    g_TP = 0;
end