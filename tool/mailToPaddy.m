function mailToPaddy(recipients,subject,message,attachments)
    % Set properties
    setpref('Internet', ...
            {'SMTP_Server','E_mail','SMTP_Username','SMTP_Password'}, ...
            {'smtp.126.com','paddychang@126.com','paddychang','billchang159357'});
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    % Send email
    if nargin == 2
        sendmail(recipients,subject);
    elseif nargin == 3
        sendmail(recipients,subject,message);
    elseif nargin == 4
        sendmail(recipients,subject,message,attachments);
    else
        disp('Can not support arguments.');
    end
    % Clear properties
    props.setProperty('mail.smtp.auto','false');
    setpref('Internet', ...
            {'SMTP_Server','E_mail','SMTP_Username','SMTP_Password'}, ...
            {'','','',''});
end