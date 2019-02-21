function trdflag = apple(open,high,low,close)
    % input arugment should be 1 minute data
    longFlag = -1;
    shortFlag = -1;
    len = length(close);
    I = 3;
    II = 15;
    III = 15;
    %---------------------------------------------------------------------------
    %                I     II     III
    %   end     1
    %   end-1   2
    %   end-2   3
    %   end-3   4
    %   end-4   5
    %---------------------------------------------------------------------------
    slope = zeros(5);
    lsr = zeros(5);
    % calculate slope and long short ratio
    for i = len-4 : len
        row = len - i + 1;
        slope(row,1) = (close(i) - open(i-I+1))/I;
        slope(row,2) = (close(i) - open(i-II+1))/II;
        slope(row,3) = (close(i) - open(i-III+1))/III;
        lsr(row,1) = (close(i) - min(low(i-I+1:i)))/(max(high(i-I+1:i)) - close(i));
        lsr(row,2) = (close(i) - min(low(i-II+1:i)))/(max(high(i-II+1:i)) - close(i));
        lsr(row,3) = (close(i) - min(low(i-III+1:i)))/(max(high(i-III+1:i)) - close(i));
    end
    %---------------------------------------------------------------------------
    % judge long or short flag
    %---------------------------------------------------------------------------
    % close long
    if (slope(1,1) < 0) && (slope(2,1) > 0) && ...
       ((slope(1,2) < slope(2,2)) || (slope(1,2) < slope(3,2))) 
        longFlag = 0;
    end
    % close short
    if (slope(1,1) > 0) && (slope(2,1) < 0) && ...
       ((slope(1,2) > slope(2,2)) || (slope(1,2) > slope(3,2))) 
        shortFlag = 0;
    end
    % open long(revert state) 
    if 
        longFlag = 1;
        shortFlag = 0;
    end
    % open short(revert state)
    if 
        longFlag = 0;
        shortFlag = 1;
    end
    %---------------------------------------------------------------------------
    trdflag = [longFlag,shortFlag];
end