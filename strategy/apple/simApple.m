function simApple()
    log = LogTool;
    sim = SimBench(EnumType.ON,log);
    % set trade seat properties
    sim.m_TrdSeat.saveMoney(20000);
    sim.m_TrdSeat.setRiskCtrl(0.9,1);
    sim.m_TrdSeat.setDebugSwitch(EnumType.ON);
    % regist e_SimInit event callback function
    sim.registerEvent('e_SimInit',@initApple);
    % regist e_SimExit event callback function
    sim.registerEvent('e_SimExit',@exitApple);
    % regist e_OnBar event callback function
    sim.registerEvent('e_OnBar',@OnBarApple);
    % set task trigger time
    sim.m_TaskTime = datetime('14:55:00','InputFormat','HH:mm:ss');
    % regist e_OnTask event callback function
    sim.registerEvent('e_OnTask',@OnTaskApple);
    % start up simulation
    flag = sim.startSimulate(datetime(2016,9,1,9,1,0),datetime(2016,11,15,15,0,0));
    % output simulation results
    if flag == 1
        sim.exportResults;
    end
    % delete SimBench object
    sim.delete;
end