function [R,xmin,xrange] = dscore(x,dim)
    if isempty(x)
        return;
    end
    if nargin < 2
        dim = 1;
    end
    xmin = min(x,[],dim);
    xrange = range(x,dim);
    R = (x-xmin)./xrange;
end