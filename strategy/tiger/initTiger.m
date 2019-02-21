function initTiger()
    global g_Tiger_Valid;
    g_Tiger_Valid = chkLicense('TigerPara.dat','Tiger_1.0');
    global g_Tiger_Log;
    g_Tiger_Log = LogTool('Tiger.log');
%     msg = sprintf('The tiger strategy start at %s.',datestr(now));
%     mailToPaddy('paddy.chang@valuemaster.cn','Tiger Strategy Start',msg);
end