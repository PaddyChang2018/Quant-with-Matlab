function exitDove()
    global g_Dove_Valid;
    global g_Dove_Log;
%     global g_Dove_IP;
    %
    stampLicense('DovePara.dat');
    g_Dove_Valid = false;
%     tmS = datestr(now);
%     g_Dove_Log.printInfo('The dove strategy exit at %s.',tmS);
    if isvalid(g_Dove_Log)
        g_Dove_Log.delete;
    end
%     msg = sprintf('The dove strategy exit at %s.\n\n%s',tmS,g_Dove_IP);
%     mailToPaddy('paddy.chang@valuemaster.cn','Dove Strategy Exit',msg,'Dove.log');
end