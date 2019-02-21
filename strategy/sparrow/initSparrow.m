function initSparrow()
    global g_Sparrow_Valid;
    global g_Sparrow_Log;
%     global g_Sparrow_IP;
    %
    g_Sparrow_Valid = chkLicense('SparrowPara.dat','Sparrow_1.0');
    g_Sparrow_Log = LogTool('Sparrow.log');
%     tmS = datestr(now);
%     g_Sparrow_Log.printInfo('The sparrow strategy start at %s.',tmS);
%     if ispc
%         [~,g_Sparrow_IP] = dos('ipconfig /all');
%     elseif isunix
%     elseif ismac
%     else
%         g_Sparrow_Log.printFatal('Sparrow strategy can not recognize OS type.');
%     end
    %
%     if g_Sparrow_Valid
%         tmS = datestr(now);
%         msg = sprintf('The sparrow strategy start at %s.\n\n%s', ...
%                       tmS,g_Sparrow_IP);
%         mailToPaddy('paddy.chang@valuemaster.cn','Sparrow Strategy Start',msg);
%     end
end