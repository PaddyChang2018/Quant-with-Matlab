function idxVal = IndexCalFun(YesterdayIdx,LstPrcVtr,StmtPrcVtr,ContSizeVtr,Type, ...
                              ExtnLstPrcVtr,ExtnStmtPrcVtr,ExtnDay)
    %%
    % YesterdayIdx   : yesterday close index value
    % LstPrcVtr      : main contract last price
    % StmtPrcVtr     : main contract yesterday settlement price
    % ContSizeVtr    : contract size
    % Type           : output precision
    % ExtnLstPrcVtr  : extension main contract last price
    % ExtnStmtPrcVtr : extension main yesterday settlement price
    % ExtnDay        : extension day number
    %%
    if nargin == 5
        idxVal = YesterdayIdx * (ContSizeVtr .* LstPrcVtr) / (ContSizeVtr .* StmtPrcVtr);
    elseif nargin == 8
        ratio = ExtnDay * 0.2;
        LstPrcVtr = (1-ratio) .* LstPrcVtr + ratio .* ExtnLstPrcVtr;
        StmtPrcVtr = (1-ratio) .* StmtPrcVtr + ratio .* ExtnStmtPrcVtr;
        idxVal = YesterdayIdx * (ContSizeVtr .* LstPrcVtr) / (ContSizeVtr .* StmtPrcVtr);
    end
    %
    if Type == 0
        idxVal = round(idxVal);
    elseif Type == 1
        intv = fix(idxVal);
        dec = idxVal - intv;
        if (dec <= 0.25)
            idxVal = intv;
        elseif (dec > 0.25) && (dec <= 0.75)
            idxVal = intv + 0.5;
        elseif (dec > 0.75) && (dec < 1)
            idxVal = intv + 1;
        end        
    elseif Type == 2
        idxVal = round(idxVal,1);
    end
end
            