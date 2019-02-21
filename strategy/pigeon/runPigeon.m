function runPigeon(S)
    tic;
    lenS = length(S);
    if lenS < 500
        return;
    end
    %
    tN = floor(lenS/10);
    opnLG = zeros(tN,1);
    clsLG = zeros(tN,1);
    opnST = zeros(tN,1);
    clsST = zeros(tN,1);
    opnLGidx = 1;
    clsLGidx = 1;
    opnSTidx = 1;
    clsSTidx = 1;
    lgLot = 0;
    stLot = 0;
    %
    initPigeon();
    for i = 500:lenS
        ops = pigeon(S(i-499:i),lgLot,stLot);
        if ops(1) > 0
            lgLot = lgLot + ops(1);
            opnLG(opnLGidx) = i;
            opnLGidx = opnLGidx + 1;
        elseif ops(1) < 0
            lgLot = lgLot + ops(1);
            clsLG(clsLGidx) = i;
            clsLGidx = clsLGidx + 1;
        end
        if ops(2) > 0
            stLot = stLot + ops(2);
            opnST(opnSTidx) = i;
            opnSTidx = opnSTidx + 1;
        elseif ops(2) < 0 
            stLot = stLot + ops(2);
            clsST(clsSTidx) = i;
            clsSTidx = clsSTidx + 1;
        end
    end
    exitPigeon();
    %
    if opnLGidx > 1 
        opnLG = opnLG(1:opnLGidx - 1);
    else
        opnLG = [];
    end
    if clsLGidx > 1
        clsLG = clsLG(1:clsLGidx - 1);
    else
        clsLG = [];
    end
    if opnSTidx > 1
        opnST = opnST(1:opnSTidx - 1);
    else
        opnST = [];
    end
    if clsSTidx > 1
        clsST = clsST(1:clsSTidx - 1);
    else
        clsST = [];
    end
    % draw chart
    ran = range(S);
    figure('Name','Pigeon');
    plot(S);
    hold on;
    scatter(opnLG,S(opnLG),[],'r','^','filled');
%     scatter(clsLG,S(clsLG),[],'r','^');
    scatter(opnST,S(opnST),[],'g','v','filled');
%     scatter(clsST,S(clsST),[],'g','v');
    hold off;
    axis([1, lenS, min(S)-0.075*ran, max(S)+0.075*ran]);
    grid;
%     legend('Price','OpnLG','ClsLG','OpnST','ClsST');
    legend('Price','OpnLG','OpnST');
    title('Pigeon Back Test Result');
    xlabel('Time Series No.');
    ylabel('Price');
    toc;
end