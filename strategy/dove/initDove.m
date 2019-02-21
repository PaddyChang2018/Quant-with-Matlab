function initDove()
    global g_Dove_Valid;
    global g_Dove_Log;
%     global g_Dove_IP;
    %
    g_Dove_Valid = chkLicense('DovePara.dat','Dove_1.0');
    g_Dove_Log = LogTool('Dove.log');
%     tmS = datestr(now);
%     g_Dove_Log.printInfo('The dove strategy start at %s.',tmS);
%     if ispc
%         [~,g_Dove_IP] = dos('ipconfig /all');
%     elseif isunix
%     elseif ismac
%     else
%         g_Dove_Log.printFatal('The dove strategy can not recognize OS type.');
%     end
%     %
%     if g_Dove_Valid
%         msg = sprintf('The dove strategy start at %s.\n\n%s', ...
%                       tmS,g_Dove_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Dove Strategy Start',msg);
%     end
end