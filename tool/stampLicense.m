function stat = stampLicense(licfile)
    stat = false;
    if (exist(licfile,'file') ~= 2)
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
        licst.ValidFlag = lic(idx(1)+1 : idx(2)-1);
        licst.SN = lic(idx(3)+1 : idx(4)-1);
        licst.LicDays = lic(idx(5)+1 : idx(6)-1);
        licst.ExpireDate = lic(idx(7)+1 : idx(8)-1);
        licst.Mac = lic(idx(11)+1 : idx(12)-1);
    catch
        return;
    end
    % update license timestamp
    licst.Timestamp = datestr(now) - 2;
    %
    % rebuild license content
    lic = sprintf('%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s#%s', ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.ValidFlag, ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.SN, ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.LicDays, ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.ExpireDate, ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.Timestamp, ...
                  num2str(floor(rand(1,50)*10)) - 5, ...
                  licst.Mac, ...
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
    %
    stat = true;
end