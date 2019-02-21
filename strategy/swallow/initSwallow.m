function initSwallow()
    global g_Swallow_Valid;
    global g_Swallow_Log;
%     global g_Swallow_IP;
    %
    g_Swallow_Valid = chkLicense('SwallowPara.dat','Swallow_1.0');
    g_Swallow_Log = LogTool('Swallow.log');
%     tmS = datestr(now);
%     g_Swallow_Log.printInfo('The swallow strategy start at %s.',tmS);
%     if ispc
%         [~,g_Swallow_IP] = dos('ipconfig /all');
%     elseif isunix
%     elseif ismac
%     else
%         g_Swallow_Log.printFatal('Swallow strategy can not recognize OS type.');
%     end
%     %
%     if g_Swallow_Valid
%         msg = sprintf('The swallow strategy start at %s.\n\n%s', ...
%                       tmS,g_Swallow_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Swallow Strategy Start',msg);
%     end
end