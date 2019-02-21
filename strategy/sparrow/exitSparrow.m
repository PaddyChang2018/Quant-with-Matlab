function exitSparrow()
    global g_Sparrow_Valid;
    global g_Sparrow_Log;
%     global g_Sparrow_IP;
    %
    stampLicense('SparrowPara.dat');
    g_Sparrow_Valid = false;
%     tmS = datestr(now);
%     g_Sparrow_Log.printInfo('The sparrow strategy exit at %s.',tmS);
    if isvalid(g_Sparrow_Log)
        g_Sparrow_Log.delete;
    end
%     msg = sprintf('The sparrow strategy exit at %s.\n\n%s',tmS,g_Sparrow_IP);
%     mailToPaddy('paddy.chang@valuemaster.cn','Sparrow Strategy Exit',msg,'Sparrow.log');
end