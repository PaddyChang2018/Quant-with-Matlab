%
% R. Boldi
% Zayed University, Dubai, UAE
% 2016
%
% test / compare the two granger_cause routines
%
%   1) [  F,  c_v ,                     best_x_lag , best_y_lag  ] =  granger_cause( .... );
%
%   2) [  F1, c_v1,   Fprob ,   dBIC  , best_x_lag1, best_y_lag1 ] =  granger_cause_1(......) ;
%
%
%   alo make histogram of Prob(F)  returned by granger_cause_1 ( should be uniform  0 .. 1 distribution )
%
% R. Boldi -  June 2014
% Zayed University, UAE
%
clear all ;
close all ;



%
% test missing numbers
%

max_lag   = 2;
max_x_lag =  max_lag;   use_best_x = 1 ;
max_y_lag =  max_lag;   use_best_y = 1 ;
firstYlag = 1 ;
alpha     = 0.05 ;

tmp_n =     50 ;

x = randn( tmp_n , 1)         ;
y = randn( tmp_n , 1)         ;


x(12) = NaN ;

%
%
%     Granger_cause_1
%
use_best_x = 0;
use_best_y = 0 ;
[  F , c_v ,   Fprob , Fprob_cor  dBIC  , best_x_lag , best_y_lag    ] = ...
    gctest(x, y,  alpha, max_x_lag , use_best_x, ...
    max_y_lag , use_best_y, firstYlag , ...
    'xName','yName', 0 , '.', 'Fprefis','Ptitle', 0 ) ;

F, Fprob





%
% the original
%
[F, c_v] = ...
    granger_cause(x, y,  alpha, max_lag             ) ;
 
F, Fprob






%
%
% monte carlo simulation
%   does granger_cause_1 return Probs  OK?
%   should be uniform [ 0 .. 1  ]
%
%
for tmp_n =   [ 50   ]   ;  % length of the data series
    for     max_lag   = [ 1  3  10 ];
        
        tmp_ntrials = 4000        ;
        
        nYes   = 0 ;
        nYes_1  = 0 ;
        nYes_1b = 0 ;
        
        fprobs     = zeros(tmp_ntrials,1);
        fprobs1    = zeros(tmp_ntrials,1);
        fprobsCorr = zeros(tmp_ntrials,1);
        fprobsFixed = zeros(tmp_ntrials,1);
        
        
        for i = 1:tmp_ntrials
            
            max_x_lag =  max_lag;   use_best_x = 1 ;
            max_y_lag =  max_lag;   use_best_y = 1 ;
            firstYlag = 1 ;
            alpha     = 0.05 ;
            
            
            x = randn( tmp_n , 1)         ;
            y = randn( tmp_n , 1)         ;
            
            %
            %
            % Boldi's mod of the original
            %
            [  F , c_v ,   Fprob , Fprob_cor  dBIC  , best_x_lag , best_y_lag    ] = ...
                gctest(x, y,  alpha, max_x_lag , use_best_x, ...
                max_y_lag , use_best_y, firstYlag , ...
                'xName','yName', 0 , '.', 'Fprefis','Ptitle', 0 ) ;
            
            fprobs1 (i)    = Fprob ;
            fprobsCorr (i) = Fprob_cor ;
            
            %
            % the original
            %
            [  F, c_v  ] = ...
                granger_cause(x, y,  alpha, max_lag             ) ;
            fprobs (i) = Fprob ;
            
            
            %
            % use fixed lags
            %
            use_best_x = 0;
            use_best_y = 0 ;
            [  F , c_v ,   Fprob , Fprob_cor  dBIC  , best_x_lag , best_y_lag    ] = ...
                gctest(x, y,  alpha, max_x_lag , use_best_x, ...
                max_y_lag , use_best_y, firstYlag , ...
                'xName','yName', 0 , '.', 'Fprefis','Ptitle', 0 ) ;
            
            fprobsFixed (i) = Fprob ;
            
            
            
            
        end ; % nTrials
        
        
        
        
        figure;
        
        %
        % original granger_cuase
        %
        
        subplot( 2,2, 1 );
        
        hist(fprobs, 50); hold all
        title('granger-cause    ');
        text(0.0 , 1.20, sprintf('  N = %d ; MaxLag = %d ', ...
            tmp_n, max_lag ), 'units', 'normalized');
        
        xx = [ 0 1 ];
        yy = tmp_ntrials/50;
        xlim=get(gca,'xlim');
        line( xlim, [yy yy],'Color','g','linewidth',2);
        
        line(xx,yy,'Color','red');
        set (gca, 'xminortick', 'on', 'yminortick', 'on'); grid('on');
        drawnow() ; refresh() ;
        
        %
        %   granger_cuase_1
        %
        
        
        subplot( 2,2, 2 );
        
            use_best_x = 1;
            use_best_y = 1 ;
        
        
        hist(fprobs1, 50); hold all;
        xx = [ 0 1 ];
        yy = tmp_ntrials/50;
        xlim=get(gca,'xlim');
        line( xlim, [yy yy],'Color','g','linewidth',2);
        
        title('granger-cause-1  ');
        text(0.00 , 1.20, sprintf('N %d; xLag %d; bestX %d; yLag %d; bestY %d', ...
            tmp_n, max_x_lag, use_best_x , max_y_lag, use_best_y  ), 'units', 'normalized');
        
        set (gca, 'xminortick', 'on', 'yminortick', 'on'); grid('on');
        drawnow() ; refresh() ;
        
        %
        %
        % check ad-hoc correction
        %
        subplot( 2,2, 3 );
        
        hist(fprobsCorr, 50); hold all;
        xx = [ 0 1 ];
        yy = tmp_ntrials/50;
        xlim=get(gca,'xlim');
        line( xlim, [yy yy],'Color','g','linewidth',2);
        
        title('granger-cause-1 Fprob corrected');
        text(0.01 , 1.20, sprintf('N %d; xLag %d; bestX %d; yLag %d; bestY %d', ...
            tmp_n, max_x_lag, use_best_x , max_y_lag, use_best_y  ), 'units', 'normalized');
        
        set (gca, 'xminortick', 'on', 'yminortick', 'on'); grid('on');
        drawnow() ; refresh() ;
        
        
        %
        %
        % fixed labs - Fprob is OK
        %
        subplot( 2,2, 4 );
        
        hist(fprobsFixed, 50); hold all;
        xx = [ 0 1 ];
        yy = tmp_ntrials/50;
        xlim=get(gca,'xlim');
        line( xlim, [yy yy],'Color','g','linewidth',2);
        
        use_best_x = 0 ;
        use_best_y = 0 ;
        title('granger-cause-1 Fixed Lags');
        text(0.00 , 1.2, sprintf('N %d; xLag %d; bestX %d; yLag %d; bestY %d', ...
            tmp_n, max_x_lag, use_best_x , max_y_lag, use_best_y  ), 'units', 'normalized');
        
        set (gca, 'xminortick', 'on', 'yminortick', 'on'); grid('on');
        drawnow() ; refresh() ;
        
        
        
        
        
        
        
        
        HomeDir = '.';
        strFN = sprintf('%s/granger_1_%d_%d_%d_%d_%d',HomeDir,  tmp_n, max_x_lag, use_best_x , max_y_lag, use_best_y );
        print(strFN,'-dpng' , '-r500') ;
        fprintf('%s\n', strFN);
        
        %
        
    end  % max lag
    
    
end % data length

