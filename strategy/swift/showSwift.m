function updn = showSwift(S,pN,bkN,extN)
    if nargin == 2
        bkN = 300;
        extN = 100;
    elseif nargin == 3
        extN = ceil(bkN/3);
    end
    %
    if (length(S) < pN) || (length(S(1:pN)) < bkN) || (length(S(pN:end)) < extN)
        return;
    end
    %
    tS = S(pN - bkN + 1:pN + extN);
    rS = price2ret(S(pN - bkN + 1:pN)) * 100;
    dlt = std(rS);
    %
    invRS = flipud(rS(end-99:end));
    fst = find(abs(invRS) > dlt,1);
    if fst <= 12
        updn = 0;
    else
        updn = sum(invRS(1:fst-1));
    end
    %
    mxX = bkN + extN;
    %
    figure('Name',sprintf('Log Return-%s',num2str(pN)));
    subplot(2,1,1);
    hold on;
    plot(tS,'b');
    scatter(bkN,tS(bkN),[],'r','filled');
    hold off;
    axis([1, mxX, min(tS) - 50, max(tS) + 50]);
    title('Price');
    grid;
%     subplot(2,1,2);
%     hold on;
%     plot(ones(mxX,1)*dlt,'b');
%     plot(ones(mxX,1)*2*dlt,'k');
%     plot(ones(mxX,1)*(-dlt),'b');
%     plot(ones(mxX,1)*2*(-dlt),'k');
%     stem(find(rS>0)+1,rS(rS>0),'r');
%     stem(find(rS<0)+1,rS(rS<0),'g');  
%     hold off;
%     axis([1, mxX, min(rS) - 0.3, max(rS) + 0.3]);
%     legend(num2str(dlt),num2str(2*dlt));
%     title('Log Return');
%     grid;
    subplot(2,1,2);
    plot(2:bkN,cumsum(rS));
    axis([1, mxX, min(cumsum(rS)) - 0.3, max(cumsum(rS)) + 0.3]);
    grid;
%     drs = diff(rS);
%     subplot(2,1,2);
%     hold on;
%     plot(3:bkN,cumsum(drs));
%     plot(zeros(mxX,1));
%     hold off;
%     axis([1, mxX, min(cumsum(drs)) - 0.1, max(cumsum(drs)) + 0.1]);
end