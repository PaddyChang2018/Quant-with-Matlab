function simOrange()
    log = LogTool;
    sim = SimBench(EnumType.ON,log);
    % set trade seat properties
    sim.m_TrdSeat.saveMoney(20000);
    sim.m_TrdSeat.setRiskCtrl(0.9,2);
    sim.m_TrdSeat.setDebugSwitch(EnumType.ON);
    % regist e_SimInit event callback function
    sim.registerEvent('e_SimInit',@initOrange);
    % regist e_SimExit event callback function
    sim.registerEvent('e_SimExit',@exitOrange);
    % regist e_OnBar event callback function
    sim.registerEvent('e_OnBar',@OnBarOrange);
    % start up simulation
    sim.startSimulate(datetime(2016,10,10,9,1,0),datetime(2016,10,30,15,0,0));
    % output simulation results
    sim.exportResults;
    % delete SimBench object
    sim.delete;
end