function [outcomes,...
    outcomeString]          = estimateGnBStaticOutcomes(accelData,...
                                rotData, fs, isAndroid)

accelMLxAPxVert             = preprocessGnBStaticStream(accelData,...
                                rotData, fs, isAndroid);

%% Compute outputs
[stabilityR,...
    stabilityML,...
    stabilityAP]             = estimatePosturalStability(accelMLxAPxVert);

outcomes                    = [stabilityR, stabilityML, stabilityAP];
outcomeString               = sprintf(strcat(...
    'Postural stability R:  %0.16f -ln[m/sec/sec]\n',...
    'Postural stability ML:  %0.16f -ln[m/sec/sec]\n',...
    'Postural stability AP:  %0.16f -ln[m/sec/sec]\n'...
    ),...
    outcomes);
end