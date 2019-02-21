function impsF = judgeImpulse(S)
    [C,L] = wavedec(S,6,'rbio5.5');
    trd = wrcoef('a',C,L,'rbio5.5',6);
    trdI = gradient(trd,0.01);
    trdII = gradient(trdI,0.5);
    tS = trdII(end-49:end);
    upflag = false;
    dnflag = false;
    mulNebor = 4;
    mulDes = 3;
    wing = 10;
    lenS = length(tS);
    if lenS < wing
        impsF = 0;
        return;
    end
    %
    [xv,xi] = max(tS);
    if xi <= wing
        stIdx = 1;
    else
        stIdx = xi - wing;
    end
    if xi > lenS - wing
        edIdx = lenS;
    else
        edIdx = xi + wing;
    end
    mxDes = sort(tS(stIdx:edIdx),'descend');
    tmp = tS(tS(stIdx:edIdx)~=xv);
    mn = mean(tmp(tmp>0));
    if ((xv > mn * mulNebor) && (mn > 0)) || ...
       ((mxDes(1) > (mxDes(2) * mulDes)) && (mxDes(2) > 0))
        upflag = true;
    end
    %
    [nv,ni] = min(tS);
    if ni <= wing
        stIdx = 1;
    else
        stIdx = ni - wing;
    end
    if ni > lenS - wing
        edIdx = lenS;
    else
        edIdx = ni + wing;
    end
    mnAsc = sort(tS(stIdx:edIdx));
    tmp = tS(tS(stIdx:edIdx)~=nv);
    mn = mean(tmp(tmp<0));
    if ((nv < mn * mulNebor) && (mn < 0)) || ...
       ((mnAsc(1) < (mnAsc(2) * mulDes)) && (mnAsc(2) < 0))
        dnflag = true;
    end
    %
    if upflag && dnflag
        if ((xv > -nv) && (ni < xi)) || ((xv > -nv*1.5) && (xi < ni))
            F = 1;
        else
            F = -1;
        end
    elseif upflag
        F = 1;
    elseif dnflag
        F = -1;
    else 
        F = 0;
    end
    %
    if F > 0
        if xv > 70 
            impsF = 3;
        elseif xv > 50
            impsF = 2;
        elseif xv > 30
            impsF = 1;
        else
            impsF = 0;
        end
    elseif F < 0
        if nv < -70
            impsF = -3;
        elseif nv < -50
            impsF = -2;
        elseif nv < -30
            impsF = -1;
        else
            impsF = 0;
        end
    else
        impsF = 0;
    end
end