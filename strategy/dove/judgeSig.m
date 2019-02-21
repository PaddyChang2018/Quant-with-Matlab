function [zeroF,sigF] = judgeSig(S)
    %
    sigF = 0;
    %
    [C,L] = wavedec(S,4,'coif4');
    sig = wrcoef('a',C,L,'coif4',4);
    sigI = gradient(sig,0.1);
    sigII = gradient(sigI,0.1);
    %
    pN = 3;
    if abs(sigI(end) - sigI(end-pN)) == abs(sigI(end)) + abs(sigI(end-pN))
        zeroF = true;
        invSigI = flip(sigI(end-29:end));
        if sigI(end) > 0       % up cross
            [nv,ni] = min(invSigI);
            if nv/ni < -1
                sigF = 1;
            end
        elseif sigI(end) < 0   % down cross
            [xv,xi] = max(invSigI);
            if xv/xi > 1
                sigF = -1;
            end
        end
    else
        zeroF = false;
        invSigI = flip(sigI(end-49:end));
        if (sigI(end-pN) > 0) && (sigII(end-pN) > 0)
            sti = find(invSigI < 0,1);
            [nv,ni] = min(invSigI);
            if nv/(ni - sti) < -1
                sigF = 3;
            end
        elseif (sigI(end) > 0) && (sigII(end) < 0) && (sigII(end-pN) > 0)
            zi = find(invSigI < 0,1);
            if sigI(end)/zi > 1
                sigF = 2;
            end
        elseif (sigI(end) > 0) && (sigII(end-pN) < 0)
            zi = find(invSigI < 0,1);
            [xv,xi] = max(invSigI(1:zi));
            if xv/(zi - xi) > 1
                sigF = 1;
            end
        elseif (sigI(end-pN) < 0) && (sigII(end-pN) < 0)
            sti = find(invSigI > 0,1);
            [xv,xi] = max(invSigI);
            if xv/(xi - sti) > 1
                sigF = -3;
            end
        elseif (sigI(end) < 0) && (sigII(end) > 0) && (sigII(end-pN) < 0)
            zi = find(invSigI > 0,1);
            if sigI(end)/zi < -1
                sigF = -2;
            end
        elseif (sigI(end) < 0) && (sigII(end-pN) > 0)
             zi = find(invSigI > 0,1);
            [nv,ni] = min(invSigI(1:zi));
            if nv/(zi - ni) < -1
                sigF = -1;
            end
        end
    end
end