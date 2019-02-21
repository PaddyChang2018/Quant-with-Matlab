function initOrange(sim,~)
    % book 1 minute bar series
    if EnumType.FALSE == sim.bookBarSeries('m1701',EnumType.M1)
        log.printFatal('Error! simOrange() can not book m1701 M1 bar series.');
        sim.delete;
        return;
    end
    % book 5 minute bar series
    if EnumType.FALSE == sim.bookBarSeries('m1701',EnumType.M5)
        log.printFatal('Error! simOrange() can not book m1701 M5 bar series.');
        sim.delete;
        return;
    end
    if EnumType.FALSE == sim.bookBarSeries('a1701',EnumType.M5)
        log.printFatal('Error! simOrange() can not book a1701 M5 bar series.');
        sim.delete;
        return;
    end
    if EnumType.FALSE == sim.bookBarSeries('y1701',EnumType.M5)
        log.printFatal('Error! simOrange() can not book y1701 M5 bar series.');
        sim.delete;
        return;
    end
    % book 15 minute bar series
    if EnumType.FALSE == sim.bookBarSeries('m1701',EnumType.M15)
        log.printFatal('Error! simOrange() can not book m1701 M15 bar series.');
        sim.delete;
        return;
    end
    if EnumType.FALSE == sim.bookBarSeries('a1701',EnumType.M15)
        log.printFatal('Error! simOrange() can not book a1701 M15 bar series.');
        sim.delete;
        return;
    end
    if EnumType.FALSE == sim.bookBarSeries('y1701',EnumType.M15)
        log.printFatal('Error! simOrange() can not book y1701 M15 bar series.');
        sim.delete;
        return;
    end
    % book trade instrument
    if EnumType.FALSE == sim.bookTrdInstID('m1701')
        log.printFatal('Error! simOrange() can not book m1701 trade instument.');
        sim.delete;
        return;
    end
    % set simulate drive instrument and timeframe
    if EnumType.FALSE == sim.setSimDrvMode('m1701',EnumType.M1)
        log.printFatal('Error! setSimDrvMode failed.');
        sim.delete;
        return;
    end
end