function [avgY,mseY,mdeY] = fcastARIMA(S,estN,fitN,fctN,simN)
    % ARIMA model to forcast
    avgY = [];
    mseY = [];
    mdeY = [];
    %
    if nargin == 1
        estN = 36;
        fitN = 12;
        fctN = 24;
        simN = 100;
    elseif nargin == 2
        fitN = 12;
        fctN = 24;
        simN = 100;
    elseif nargin == 3
        fctN = 24;
        simN = 100;
    elseif nargin == 4
        simN = 100;
    end
    %
    if length(S) < estN+fitN
        return;
    end
    mdl = arima('Constant',0,'ARLags',1,'D',1,'MALags',1);
    try
        est = estimate(mdl,S(end-fitN-estN+1:end-fitN),'Display','off');
    catch
        disp('Model Estimate Failed');
        return;
    end
    rng('default');
    Yset = simulate(est,fitN+fctN,'NumPaths',simN,'Y0',S(end-fitN-estN+1:end-fitN));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % R2016b 64bit
    %res = (Yset(1:12,:) - cmpS) .^ 2;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % R2015b 32bit
    res = (Yset(1:fitN,:) - repmat(S(end-fitN+1:end),1,simN)) .^ 2;
    [~,mseIdx] = min(sum(res));
    [~,mdeIdx] = min(abs(res(end,:)));
    mseY = Yset(fitN+1:end,mseIdx);
    mdeY = Yset(fitN+1:end,mdeIdx);
    avgY = (mseY + mdeY)/2;
end