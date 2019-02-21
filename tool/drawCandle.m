%-------------------------------------------------------------------------------
% one argument:
%               varargin{1} : BarSeries object
% four argument:
%               varargin{1} : open 
%               varargin{2} : high
%               varargin{3} : low
%               varargin{4} : close
% five argument:
%               varargin{1} : open 
%               varargin{2} : high
%               varargin{3} : low
%               varargin{4} : close
%               varargin{5} : time(datetime type or date string)
%-------------------------------------------------------------------------------                            
function drawCandle(varargin)
    if length(varargin) == 1
        if isa(varargin{1},'BarSeries')
            varargin{1}.drawCandle;
            return;
        end
    elseif length(varargin) == 4
        open = varargin{1};
        high = varargin{2};
        low = varargin{3};
        close = varargin{4};
    elseif length(varargin) == 5
        open = varargin{1};
        high = varargin{2};
        low = varargin{3};
        close = varargin{4};
        time = varargin{5};
    else
        return;
    end
    %
    len = length(open);
    up = find(open < close); 
    down = find(close < open); 
    equal = find(close == open);
    data = [high,low,close,open];
    Mtx1 = zeros(len,4); 
    Mtx2 = zeros(len,4);
    Mtx3 = zeros(len,4);
    Mtx1(up,:) = data(up,:);
    Mtx2(down,:) = data(down,:);
    Mtx3(equal,:) = data(equal,:);
    ma = max(high);
    mi = min(low);
    range = ma - mi;
    if length(varargin) == 5
        if len > 7
            x = 1:int32(floor(len/7)):len;
        else
            x = 1:len;
        end
        dateSA = cell(length(x),1);
        if isdatetime(time(1))
            ds = datestr(time);
            for i = 1:length(x)
                dateSA{i} = ds(x(i),:);
            end
        else
            for i = 1:length(x)
                dateSA{i} = char(time(x(i)));
            end
        end
    end
    %
    figure;
    hold on;
    candle(Mtx1(:,1),Mtx1(:,2),Mtx1(:,3),...
           Mtx1(:,4),'r');
    candle(Mtx2(:,1),Mtx2(:,2),Mtx2(:,3),...
           Mtx2(:,4),'b');
    candle(Mtx3(:,1),Mtx3(:,2),Mtx3(:,3),...
           Mtx3(:,4),'k');
    hold off;
    axis([1, len, mi-0.075*range, ma+0.075*range]);
    xlabel('Time Series');
    ylabel('Price');
    grid;
    if length(varargin) == 5
        set(gca,'XTick',x);
        set(gca,'XTickLabel',dateSA);
    end
end
