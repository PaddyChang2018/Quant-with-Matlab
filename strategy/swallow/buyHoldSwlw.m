function [tndF,bhV] = buyHoldSwlw(S)
    delta = std(S);
    %
    bhV = mean(S(end) - S(1:end-1));
    if bhV > 1.5*delta
        tndF = 3;
    elseif  bhV > delta
        tndF = 2;
    elseif bhV > 0.5*delta
        tndF = 1;
    elseif bhV < -1.5*delta
        tndF = -3;
    elseif bhV < -delta
        tndF = -2;
    elseif bhV < -0.5*delta
        tndF = -1;
    else
        tndF = 0;
    end
end