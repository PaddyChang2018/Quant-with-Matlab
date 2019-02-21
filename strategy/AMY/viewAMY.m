function viewAMY(A,M,Y)
%%
%     preA = 0.18 * Y.Close + 0.8 * M.Close;
%     resiA = A.Close - preA;
%     figure;
%     len = size(A,1);
%     plot(1:len,A.Close,1:len,M.Close,1:len,Y.Close);
%     legend('A','M','Y');
%     grid;
%     xlabel('Time No.');
%     ylabel('Price');
%     figure;
%     plot(1:len,A.Close,1:len,preA);
%     legend('A','Predict A');
%     grid;
%     xlabel('Time No.');
%     ylabel('Price');
%     figure;
%     plot(1:len,resiA);
%     grid;
%     legend('residual A');
%     xlabel('Time No.');
%     ylabel('Price');
%%
volaA = A.Close(2:end) - A.Close(1:end-1);
volaM = M.Close(2:end) - M.Close(1:end-1);
volaY = Y.Close(2:end) - Y.Close(1:end-1);
figure;
stem([volaA,volaM,volaY]);
legend('A','M','Y');
xlabel('Time No.');
ylabel('volatility');
grid;
end