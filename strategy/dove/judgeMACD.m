function macdF = judgeMACD(S)
    [~,nS] = movavg(S,5,36,'e');
    [main,nin] = macd(nS);
    pN = 3;
    if (main(end) - nin(end) > main(end-pN) - nin(end-pN)) && (main(end-pN) - nin(end-pN) > 0)
        macdF = 3;
    elseif (main(end) - nin(end) < main(end-pN) - nin(end-pN)) && (main(end-pN) - nin(end-pN) < 0)
        macdF = -3;
    elseif (main(end) - nin(end) > main(end-pN) - nin(end-pN)) && (main(end) - nin(end) > 0)
        macdF = 2;
    elseif (main(end) - nin(end) < main(end-pN) - nin(end-pN)) && (main(end) - nin(end) < 0)
        macdF = -2;
    elseif (main(end) - nin(end) < main(end-pN) - nin(end-pN)) && (main(end) - nin(end) > 0)
        macdF = 1;
    elseif (main(end) - nin(end) > main(end-pN) - nin(end-pN)) && (main(end) - nin(end) < 0)
        macdF = -1;
    else
        macdF = 0;
    end
end