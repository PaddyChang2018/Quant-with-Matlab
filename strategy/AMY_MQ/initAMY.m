function initAMY()
    global g_LastState;
    g_LastState = struct('isArbi', EnumType.FALSE, ...
                         'Li', 0, ...
                         'Ri', 0, ...
                         'LeftDir', 0, ...
                         'DA', 0, ...
                         'DM', 0, ...
                         'DY', 0, ...
                         'ArbiDiff',0);
end