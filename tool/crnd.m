function  y = crnd(pdffun,pdfdef,m,n)
    try
        xm = integral(pdffun,min(pdfdef),max(pdfdef));
    catch
        xm = mean(pdfdef);
    end
    
    cdfrnd = rand(m*n,1);
    y = zeros(m*n,1);
    options = optimset;
    options.Display = 'off';
    
    for i = 1:m*n
        funcdf = @(x) integral(pdffun,min(pdfdef),x) - cdfrnd(i);
        y(i) = fsolve(funcdf,xm,options);
    end
    y = reshape(y,[m,n]);
end