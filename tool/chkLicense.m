% licfile : license file path
% sn      : series number, should be match sn in license.dat file.
function stat = chkLicense(licfile,sn)
    stat = false;
    if (exist(licfile,'file') ~= 2)
        [~,cmdout] = dos('ipconfig /all');
        tle = sprintf('License file %s can not be found.',licfile);
        msg = sprintf('License file %s can not be found at %s.\n\n%s', ...
                      licfile,datestr(now),cmdout);
        try
            mailToPaddy('paddy.chang@valuemaster.cn',tle,msg);
        catch
            disp('Send email to Paddy error.');
        end
        return;
    end
    %
    try
        % open readonly license file
        fid = fopen(licfile,'r');
        % read license file
        lic = char(fread(fid)');
        % close readonly license file
        fclose(fid);
    catch
        fclose(fid);
        return;
    end
    %
    try
        % find separator '#' ASCII 35
        idx = strfind(lic,'#');
        % fill lic struct fields
        licst.ValidFlag = char(lic(idx(1)+1 : idx(2)-1) + 3);
        licst.SN = char(lic(idx(3)+1 : idx(4)-1) + 3);
        licst.LicDays = char(lic(idx(5)+1 : idx(6)-1) + 2);
        licst.ExpireDate = char(lic(idx(7)+1 : idx(8)-1) - 2);
        licst.Timestamp = char(lic(idx(9)+1 : idx(10)-1) + 2);
        licst.Mac = upper(char(lic(idx(11)+1 : idx(12)-1) - 15));
    catch
        return;
    end
    % judge sn
    if ~strcmp(licst.SN,sn)
        return;
    end
    % judge mac address
    if ~strcmp(licst.Mac,'00-00-00-00-00-00') && ...
       ~strcmp(licst.Mac,'00:00:00:00:00:00')
        if ispc
            [~,cmdout] = dos('ipconfig /all');
        elseif isunix || ismac
            [~,cmdout] = system('cat /sys/class/net/eth0/address');
        else
            disp('Can not recognize OS type and get mac address.');
            return;
        end
        if isempty(strfind(upper(cmdout),licst.Mac))
            tle = sprintf('Checking license %s is failed.',licst.SN);
            msg = sprintf('Checking license %s is failed for computer %s at %s.\n\n%s', ...
                          licst.SN,licst.Mac,datestr(now),cmdout);
            try
                mailToPaddy('paddy.chang@valuemaster.cn',tle,msg);
            catch
                disp('Send email to Paddy error.');
            end
            return;
        end
    end
    % judge new license has been used or not
    if strcmp(licst.ValidFlag, '0')    % new license
        licst.ValidFlag = '1';         % change new state to normal valid state
        ds = str2double(licst.LicDays);
        if ds > 0
            licst.ExpireDate = datestr(now + days(ds));
            licst.Timestamp = datestr(now);
        else
            return;
        end
    elseif strcmp(licst.ValidFlag,'1') % valid 
        if now < datenum(licst.Timestamp) || now > datenum(licst.ExpireDate)
            return;
        end
        % update timestamp
        licst.Timestamp = datestr(now);
    else                              % invalid 
        return;
    end
    % rebuild license content
    lic = sprintf('%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s', ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.ValidFlag - 3, ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.SN - 3, ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.LicDays - 2, ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.ExpireDate + 2, ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.Timestamp - 2, ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.Mac + 15, ...
                  num2str(floor(rand(1,50)*10)) - 5);
    % write new license content 
    try
        fid = fopen(licfile,'w');
        fwrite(fid,lic);
        fclose(fid);
    catch
        fclose(fid);
        return;
    end
    stat = true;
end