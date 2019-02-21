function initPigeon()
    global g_Pigeon_Valid;
    global g_Pigeon_Log;
%     global g_Pigeon_IP;
    %
    g_Pigeon_Valid = chkLicense('PigeonPara.dat','Pigeon_1.0');
    g_Pigeon_Log = LogTool('Pigeon.log');
%     tmS = datestr(now);
%     g_Pigeon_Log.printInfo('The pigeon strategy start at %s.',tmS);
%     if ispc
%         [~,g_Pigeon_IP] = dos('ipconfig /all');
%     elseif isunix
%     elseif ismac
%     else
%         g_Pigeon_Log.printFatal('The pigeon strategy can not recognize OS type.');
%     end
%     %
%     if g_Pigeon_Valid
%         msg = sprintf('The pigeon strategy start at %s.\n\n%s', ...
%                       tmS,g_Pigeon_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Pigeon Strategy Start',msg);
%     end
end