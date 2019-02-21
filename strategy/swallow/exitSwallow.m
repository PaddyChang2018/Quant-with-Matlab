function exitSwallow()
    global g_Swallow_Valid;
    global g_Swallow_Log;
%     global g_Swallow_IP;
    %
    stampLicense('SwallowPara.dat');
    g_Swallow_Valid = false;
%     tmS = datestr(now);
%     g_Swallow_Log.printInfo('The swallow strategy exit at %s.',tmS);
    if isvalid(g_Swallow_Log)
        g_Swallow_Log.delete;
    end
%     msg = sprintf('The swallow strategy exit at %s.\n\n%s',tmS,g_Swallow_IP);
%     mailToPaddy('paddy.chang@valuemaster.cn','Swallow Strategy Exit',msg,'Swallow.log');
end