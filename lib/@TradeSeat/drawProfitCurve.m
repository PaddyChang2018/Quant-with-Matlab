function drawProfitCurve(obj)
    if isempty(obj.m_CloseBox)
        return;
    end 
    %
    S = length(obj.m_CloseBox);
    pftN = zeros(S,1);
    for i=1:S
        pftN(i) = obj.m_CloseBox(i).profit;
    end
    cumPftN = cumsum(pftN);
    %
    figure;
    stem(0:length(pftN),[0;pftN]);
    if length(pftN) ~= 1
        axis([0,S,min(pftN),max(pftN)]);
    end
    legend('Orders Profit');
    title('Close Orders Profit');
    xlabel('Trade Series');
    ylabel('Profit');
    grid;
    %
    figure;
    plot(0:length(cumPftN),[0;cumPftN]);
    range = max(cumPftN) - min(cumPftN);
    if range ~= 0
        axis([0,S,min(cumPftN)-0.05*range,max(cumPftN)+0.05*range]);
    end
    legend('Cumulative Profit');
    title('Close Orders Cumulative Profit');
    xlabel('Trade Series');
    ylabel('Profit');
    grid;
end