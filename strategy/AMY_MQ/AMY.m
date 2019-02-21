function flag = AMY(A,M,Y)
    amyD = [A(2) - A(1),M(2) - M(1),Y(2) - Y(1)];
    amyDA = abs(amyD);
    % judge left index and right index
    [~,Li] = max(amyDA);
    [~,xi] = max(amyD);
    [~,ni] = min(amyD);
    if amyD(end,Li) > 0
        Ri = ni; 
    else
        Ri = xi;
    end
    % init return value
    Ldir = 0;
    % judge current arbi state
    if (abs(amyD(Li) - amyD(Ri)) >= 30)
        % locate two side, open arbitrage
        if amyD(Li) > 0
            Ldir = -1; % Sell
        else
            Ldir = 1;  % Buy
        end
    end
    %---------------------------------------------------------------------------
    % set return values
    %---------------------------------------------------------------------------
    % opncls:
    %        -1 do nothing 
    %         0 close arbitrage
    %         1 open arbitrage
    %         2 first close old arbitrage, second open new arbitrage
    opncls = -1; 
    % compare current state and last state
    global g_LastState;
    if g_LastState.isArbi == EnumType.FALSE   % no old arbitrage
        if Ldir ~= 0
            % new arbitrage
            opncls = 1;
            g_LastState.isArbi = EnumType.TRUE;
            g_LastState.Li = Li;
            g_LastState.Ri = Ri;
            g_LastState.LeftDir = Ldir;
            g_LastState.DA = amyD(end,1);
            g_LastState.DM = amyD(end,2);
            g_LastState.DY = amyD(end,3);
            g_LastState.ArbiDiff = abs(amyD(Li) - amyD(Ri));
        end
    elseif g_LastState.isArbi == EnumType.TRUE  % has arbitrage
        if g_LastState.DA ~= amyD(1) || g_LastState.DM ~= amyD(2) || ...
           g_LastState.DY ~= amyD(3)
            % judge close current arbitrage or not
            if abs(amyD(Li) - amyD(Ri)) > (g_LastState.ArbiDiff + 10)
                opncls = 0; % close current arbitrage 
                g_LastState.isArbi = EnumType.FALSE;
            end
            if Ldir ~= 0  
                % new arbitrage
                opncls = 2;
                g_LastState.isArbi = EnumType.TRUE;
                g_LastState.Li = Li;
                g_LastState.Ri = Ri;
                g_LastState.LeftDir = Ldir;
                g_LastState.DA = amyD(1);
                g_LastState.DM = amyD(2);
                g_LastState.DY = amyD(3);
                g_LastState.ArbiDiff = abs(amyD(Li) - amyD(Ri));
            end
        end
    end
    % set return values
    flag = [opncls,Li,Ri,Ldir];
end