function exitPigeon()
    global g_Pigeon_Valid;
    global g_Pigeon_Log;
%     global g_Pigeon_IP;
    %
    stampLicense('PigeonPara.dat');
    g_Pigeon_Valid = false;
%     tmS = datestr(now);
%     g_Pigeon_Log.printInfo('The pigeon strategy exit at %s.',tmS);
    if isvalid(g_Pigeon_Log)
        g_Pigeon_Log.delete;
    end
%     msg = sprintf('The pigeon strategy exit at %s.\n\n%s',tmS,g_Pigeon_IP);
%     mailToPaddy('paddy.chang@valuemaster.cn','Pigeon Strategy Exit',msg,'Pigeon.log');
end