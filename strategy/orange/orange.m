function trdflag = orange(m_M15,a_M15,y_M15,m_M5,a_M5,y_M5,price)
    longFlag = -1;
    shortFlag = -1;
    % regress 15 minute price
    m15v = 20;
    m15i = -1;
    preM15 = 0;
    for i = 20 : 5 : length(m_M15)
        X = [ones(i-1,1),a_M15(end-i+1:end-1),y_M15(end-i+1:end-1)];
        [~,~,r,~,stats] = regress(m_M15(end-i+2:end),X);
        if stats(3) < 0.05
            tmp = abs(r(end)) + abs(r(end-1)) + abs(r(end-2));
            if  tmp < m15v
                m15v = tmp;
                m15i = i;
            end
        end
    end
    if m15i ~= -1
        X = [ones(m15i-1,1),a_M15(end-m15i+1:end-1),y_M15(end-m15i+1:end-1)];
        b = regress(m_M15(end-m15i+2:end),X);
        preM15 = b(1) + b(2) * a_M15(end) + b(3) * y_M15(end);
    end
    % regress 5 minute price
    m5v = 10;
    m5i = -1;
    preM5 = 0;
    for i = 20 : 5 : length(m_M5)
        X = [ones(i-1,1),a_M5(end-i+1:end-1),y_M5(end-i+1:end-1)];
        [~,~,r,~,stats] = regress(m_M5(end-i+2:end),X);
        if stats(3) < 0.05
            tmp = abs(r(end)) + abs(r(end-1)) + abs(r(end-2));
            if  tmp < m5v
                m5v = tmp;
                m5i = i;
            end
        end
    end
    if m5i ~= -1
        X = [ones(m5i-1,1),a_M5(end-m5i+1:end-1),y_M5(end-m5i+1:end-1)];
        b = regress(m_M5(end-m5i+2:end),X);
        preM5 = b(1) + b(2) * a_M5(end) + b(3) * y_M5(end);
    end
    %--------------------------------------------------------------------
    % close long position
    if preM15 ~= 0 && price >= preM15 + 3
        longFlag = 0;
    end
    % close short position
    if preM15 ~= 0 && price <= preM15 + 3
        shortFlag = 0;
    end
    % open long position
%     if preD1 ~= 0 && price <= preD1 - 10
        if preM15 ~= 0 && price <= preM15 - 5
            if preM5 ~= 0 && price <= preM5
                longFlag = 1;
                shortFlag = 0;
            end
        end
%     end
    % open short position
%     if preD1 ~= 0 && price >= preD1 + 10
        if preM15 ~= 0 && price >= preM15 + 5
            if preM5 ~= 0 && price >= preM5
                shortFlag = 1;
                longFlag = 0;
            end
        end
%     end
    %--------------------------------------------------------------------
    trdflag = [longFlag,shortFlag];
end