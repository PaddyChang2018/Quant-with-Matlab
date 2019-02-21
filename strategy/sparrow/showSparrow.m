function [bhF_L,bhF_M,bhF_S,impsF,macdF,zeroF,sigF] = showSparrow(S,pN,bkN,estN,fitN,fctN,simN)
    if nargin == 2
        bkN = 300;
        estN = 36;
        fitN = 12;
        fctN = 24;
        simN = 100;
    elseif nargin == 3
        estN = 36;
        fitN = 12;
        fctN = 24;
        simN = 100;
    elseif nargin == 4
        fitN = 12;
        fctN = 24;
        simN = 100;
    elseif nargin == 5
        fctN = 24;
        simN = 100;
    elseif nargin == 6
        simN = 100;
    end
    %
    bhF_L = NaN;
    bhF_M = NaN;
    bhF_S = NaN;
    impsF = NaN;
    macdF = NaN;
    zeroF = NaN;
    sigF = NaN;
    if (length(S) < pN) || (length(S(1:pN)) < bkN) || (length(S(pN:end)) < fctN)
        return;
    end
    tS = S(pN - bkN + 1:pN + fctN);
    wS = S(pN - bkN + 1:pN);
    [C,L] = wavedec(wS,4,'coif4');
    sig = wrcoef('a',C,L,'coif4',4);
    [C,L] = wavedec(wS,6,'rbio5.5');
    trd = wrcoef('a',C,L,'rbio5.5',6);
    %
    sigI = gradient(sig,0.1);
    sigII = gradient(sigI,0.1);
    trdI = gradient(trd,0.01);
    trdII = gradient(trdI,0.5);
    %
    [blmid,bluppr,bllowr] = bollinger(wS);
    %
    [avgY,mseY,mdeY] = fcastARIMA(wS,estN,fitN,fctN,simN);
    %
    [~,maL] = movavg(wS,5,36,'e');
    [macdSig,ninSig] = macd(maL);
    %
    bhF_L = buyHold(wS);
    bhF_M = buyHold(wS(end-199:end));
    bhF_S = buyHold(wS(end-99:end));
    impsF = judgeImpulse(wS);
    macdF = judgeMACD(wS);
    [zeroF,sigF] = judgeSig(wS);
    %
    figure('Name',num2str(pN));
    subplot(3,1,1);
    hold on;
    plot(tS,'b');
    plot(sig,'m');
    plot(bkN+1:bkN+fctN,mseY,'r');
    plot(bkN+1:bkN+fctN,mdeY,'g');
    plot(bkN+1:bkN+fctN,avgY,'k');
    scatter(bkN,wS(end),[],'r','filled');
    plot(blmid,'c');
    plot(bluppr,'k');
    plot(bllowr,'k');
    hold off;
    axis([1, bkN+fctN, min([tS;bllowr]), max([tS;bluppr])]);
    legend('Prc','Sig','mseFct','mdeFct','avgFct','Location','Northwest');
    grid;
    subplot(3,1,2);
    hold on;
    plot(sigI,'b');
    plot(sigII,'r.');
    plot(trdI,'g--');
    plot(trdII,'k');
    plot(zeros(bkN+fctN,1),'k');
    hold off;
    axis([1, bkN+fctN, min([min(trdI),min(trdII)]), max([max(trdI),max(trdII)])]);
    legend('SigI','SigII','TrdI','TrdII','Location','Northwest');
    grid;
    subplot(3,1,3);
    hold on;
    plot(macdSig);
    plot(ninSig);
    hold off;
    axis([1, bkN+fctN,min(ninSig)-1,max(ninSig)+1]);
    legend('macd','nin','Location','Northwest');
    grid;
end