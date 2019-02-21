function flag = AMY(A,M,Y)
    amyD = [A(2:end) - A(1:end-1),M(2:end) - M(1:end-1),Y(2:end) - Y(1:end-1)];
    amyDA = abs(amyD);
    % judge left index and right index
    [~,Li] = max(amyDA(end,:));
    [~,xi] = max(amyD(end,:));
    [~,ni] = min(amyD(end,:));
    if amyD(end,Li) > 0
        Ri = ni; 
    else
        Ri = xi;
    end
    % init return value
    pair = -1;
    Ldir = 0;
    % judge current arbi state
    if (amyDA(end,Li) >= 30)
        if abs(amyD(end,Li) - amyD(end,Ri)) >= amyDA(end,Li)
            % locate two side, open arbitrage
            pair = Li*10 + Ri;
            if amyD(end,Li) > 0
                Ldir = -1; % Sell
            else
                Ldir = 1;  % Buy
            end
        else
            % locate one side
            if amyDA(end,Ri) < 10
                pair = Li*10 + Ri;
                if amyD(end,Li) > 0
                    Ldir = -1; % Sell
                else
                    Ldir = 1;  % Buy
                end
            end
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
        if pair > 0
            % new arbitrage
            opncls = 1;
            g_LastState.isArbi = EnumType.TRUE;
            g_LastState.Pair = pair;
            g_LastState.LeftDir = Ldir;
            g_LastState.DA = amyD(end,1);
            g_LastState.DM = amyD(end,2);
            g_LastState.DY = amyD(end,3);
        end
    elseif g_LastState.isArbi == EnumType.TRUE  % has arbitrage
        if g_LastState.DA ~= amyD(end,1) || g_LastState.DM ~= amyD(end,2) || ...
           g_LastState.DY ~= amyD(end,3)
            oLi = floor(g_LastState.Pair/10);
            oRi = mod(g_LastState.Pair,10);
            % judge close current arbitrage or not
            if abs(amyD(end,oLi) - amyD(end,oRi)) > (abs(amyD(end-1,oLi) - amyD(end-1,oRi)) + 8)
                opncls = 0; % close current arbitrage 
                g_LastState.isArbi = EnumType.FALSE;
            end
            if pair > 0  
                if (g_LastState.Pair ~= pair) || (g_LastState.LeftDir ~= Ldir)
                    % new arbitrage
                    opncls = 2;
                    g_LastState.isArbi = EnumType.TRUE;
                    g_LastState.Pair = pair;
                    g_LastState.LeftDir = Ldir;
                    g_LastState.DA = amyD(end,1);
                    g_LastState.DM = amyD(end,2);
                    g_LastState.DY = amyD(end,3);
                end
            end
        end
    end
    % set return values
    flag = [opncls,Li,Ri,Ldir];
end