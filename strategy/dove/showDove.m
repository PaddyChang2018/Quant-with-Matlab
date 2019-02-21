function tndF = showDove(pS,pN,bkN,extN)
    if nargin == 2
        bkN = 500;
        extN = 200;
    elseif nargin == 3
        extN = ceil(bkN/4);
    end
    %
    if (length(pS) < pN) || (length(pS(1:pN)) < bkN) || (length(pS(pN:end)) < extN)
        return;
    end
    %
    tS = pS(pN - bkN + 1:pN + extN);
    S = pS(pN - bkN + 1:pN);
    [C,L] = wavedec(S,9,'coif5');
    fast = wrcoef('a',C,L,'coif5',5);
    slow = wrcoef('a',C,L,'coif5',7);
    d6 = wrcoef('d',C,L,'coif5',6);
    d7 = wrcoef('d',C,L,'coif5',7);
    D = d6 + d7;
    DI = gradient(D,0.05);
    fastI = gradient(fast,0.05);
    slowI = gradient(slow,0.05);
    %
    rngSlow = range(slow);
    dlt = slow(end) - min(slow);
    if (dlt < rngSlow * 0.4)
        tndF = -1;
    elseif dlt > rngSlow * 0.6
        tndF = 1;
    else
        tndF = 0;
    end
    %
    mxX = bkN + extN;
    %
    figure('Name',num2str(pN));
    subplot(3,1,1);
    hold on;
    plot(tS,'b');
    plot(fast,'m');
    plot(slow,'g');
    scatter(bkN,S(bkN),[],'r','filled');
    hold off;
    axis([1, mxX, min(tS)-10, max(tS)+10]);
    legend('Price','fast','slow');
    grid;
    subplot(3,1,2);
    hold on;
    plot(fastI,'r');
    plot(slowI,'b');
    plot(zeros(mxX,1),'k');
    hold off;
    axis([1, mxX, min([fastI;slowI]) - 2, max([fastI;slowI]) + 2]);
    legend('fastI','slowI');
    grid;
    subplot(3,1,3);
    hold on;
    plot(D,'b');
    plot(DI,'r');
    plot(zeros(mxX,1),'k');
    hold off;
    axis([1, mxX, min([D;DI]) - 5, max([D;DI]) + 5]);
    legend('D','DI');
    grid;
end