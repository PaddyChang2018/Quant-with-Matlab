%% calculate spread A,M,Y
prcA = a1701.Close;
prcM = m1701.Close;
prcY = y1701.Close;
spdAM = prcA - prcM;
spdYA = prcY - prcA;
spdYM = prcY - prcM;
spdYM2A = prcY + prcM - 2*prcA;
ldAM = price2ret(spdAM) * 100;
%% draw spread curve A,M,Y
len = size(spdAM,1);
figure;
plot(1:len,spdAM,'r-',1:len,spdYA,'b*',1:len,spdYM,'k:');
grid;
ylabel('Spread');
xlabel('Time No.');
legend('A-M','Y-A','Y-M');
figure;
plot(spdYM2A);
grid;
ylabel('Spread');
xlabel('Time No.');
legend('Y+M-2A');
%% draw log difference curve
figure;
subplot(2,2,1);
plot(1:size(ldAM,1),ldAM,'r-o');
grid;
xlabel('Time No.');
ylabel('log difference * 100');
title('spread log difference');
legend('A-M');
%
subplot(2,2,2);
boxplot(ldAM,'Notch','on','Labels',{'A-M'});
grid;
%
subplot(2,2,3);
hist(ldAM);
xlabel('log difference * 100');
ylabel('hist frequence');
title('log difference hist');
grid;
%
subplot(2,2,4);
grid;
normplot(ldAM);
%
figure;
yyaxis left;
plot(spdAM);
yyaxis right;
plot([0;ldAM]);
hold on;
plot(zeros(size(spdAM,1),1));
%% basic statistic variables
fprintf('mean = %f\n',mean(ldAM));
fprintf('std = %f\n',std(ldAM));
fprintf('mode = %f\n',mode(ldAM));
fprintf('median = %f\n',median(ldAM));
fprintf('range = %f\n',range(ldAM));
fprintf('skewness = %f\n',skewness(ldAM));
fprintf('kurtosis = %f\n',kurtosis(ldAM));
%% norm distribution test
[h,p,stats,ci] = jbtest(ldAM);
% [h,p,stats,ci] = jbtest(ldAM,[],0.001);
% [h,p,ci,stats] = ttest(ldAM);
% [h,p,ci,stats] = ttest(ldAM,mean(ldAM));
% [h,p,stats] = chi2gof(ldAM);
% [h,p,stats,ci] = kstest((ldAM - mean(ldAM))/std(ldAM));
% [h,p,ci,stats] = vartest(ldAM,var(ldAM));
%% regress M = f(A,Y)
% with intercept
% mdl = fitlm([prcA,prcY],prcM,'RobustOpts','ols','VarNames',{'A','Y','M'});
% % without intercept and make sure 130 RMB handle fee
% mdl2 = fitlm([prcA,prcY],prcM,'Intercept',false,'RobustOpts','ols', ...
%              'VarNames',{'A','Y','M'});
% [b,bint,r,rint,stats] = regress(prcM,[ones(size(prcA,1),1),prcA,prcY],0.01);
% rcoplot(r,rint);
% stats1 = regstats(prcM,[prcA,prcY]);
% [b1,stats2] = robustfit([prcA,prcY],prcM);
% stepwise([prcA,prcY],prcM);
%%

%% ARIMA-GARCH Model

%% clear temp variables
% clear prcA prcM prcY spdAM spdYA spdYM len;
