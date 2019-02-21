% sn      : series number
% licdays : permit days
% mac     : computer MAC address
function genLicense(sn,licdays,mac)
    if ~isnumeric(licdays) || isnan(licdays) || isempty(licdays) || ...
       isempty(sn) || ~ischar(sn)
        return;
    end
    if nargin == 2
        if ispc
            mac = '00-00-00-00-00-00';
        elseif isunix || ismac
            mac = '00:00:00:00:00:00';
        else
            disp('Can not recognize OS type.');
            disp('Set mac address 00-00-00-00-00-00 by default.');
            mac = '00-00-00-00-00-00';
        end          
    elseif nargin == 3
        if isempty(mac) || ~ischar(mac)
            return;
        end
    else
        return;
    end
    licst = struct('ValidFlag', '0', ...
                   'SN', sn, ...
                   'LicDays', num2str(licdays), ...
                   'ExpireDate', datestr(now), ...
                   'Timestamp', datestr(now), ...
                   'Mac', mac);
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
    fid = fopen('license.dat','w');
    fwrite(fid,lic);
    fclose(fid);
end