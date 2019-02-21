function viewOrange(Y,X1,X2,X3,X4,timeNum,n)
    preY = zeros(length(Y),1);
    for i = n+1 : length(Y)
        v = 100;
        idx = -1;
        for j = 5 : 5 : n
            X = [ones(j-1,1),X1(i-j:i-2),X2(i-j:i-2),X3(i-j:i-2),X4(i-j:i-2)];
            % X = [ones(j-1,1),X1(i-j:i-2),X2(i-j:i-2),X3(i-j:i-2)];
            % X = [ones(j-1,1),X1(i-j:i-2),X2(i-j:i-2)];
            [~,~,r,~,stats] = regress(Y(i-j+1:i-1),X);
            if stats(3) < 0.05
                if abs(r(end)) + abs(r(end-1)) + abs(r(end-2)) < v
                    v = abs(r(end)) + abs(r(end-1)) + abs(r(end-2));
                    idx = j;
                end
            end
        end
        if idx ~= -1
            X = [ones(idx-1,1),X1(i-idx:i-2),X2(i-idx:i-2),X3(i-idx:i-2),X4(i-idx:i-2)];
            % X = [ones(idx-1,1),X1(i-idx:i-2),X2(i-idx:i-2),X3(i-idx:i-2)];
            % X = [ones(idx-1,1),X1(i-idx:i-2),X2(i-idx:i-2)];
            b = regress(Y(i-idx+1:i-1),X);
            preY(i) = b(1) + b(2) * X1(i-1) + b(3) * X2(i-1) + b(4) * X3(i-1) + ...
                      b(5) * X4(i-1);
        else
            preY(i) = mean(Y(i-10:i-1));
            fprintf('Error! %s has not regress reuslt.\n',datestr(timeNum(i)));
        end
    end
    %
    figure;
    plot(n+1:length(Y),Y(n+1:end),'b-o', ...
         n+1:length(Y),preY(n+1:end),'r-*');
    grid;
    xlabel('Time Series');
    ylabel('Price');
    legend('Real','Predict');
    title('Orange Strategy Predict Price');
    figure;
    plot(n+1:length(Y),preY(n+1:end)-Y(n+1:end));
    grid;
    xlabel('Time Series');
    ylabel('Residual');
    legend('Residual');
    title('Orange Strategy Residual');
end
