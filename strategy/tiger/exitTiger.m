function exitTiger()
    global g_Tiger_Valid;
    global g_Tiger_Log;
    %
    g_Tiger_Valid = false;
    if isvalid(g_Tiger_Log)
        g_Tiger_Log.delete;
    end
%     msg = sprintf('The tiger strategy exit at %s.',datestr(now));
%     mailToPaddy('paddy.chang@valuemaster.cn','Tiger Strategy Exit',msg,'Tiger.log');
end