function kotlinStr      = printGnBGaitOutcomesAskotlin(outcomes)

kotlinStr               = sprintf(strcat('GnBGaitOutcomes(\n',...
                            'meanSymIndex = %0.16f,\n',...
                            'meanStepLength = %0.16f,\n',...
                            'meanStepTime = %0.16f,\n',...
                            'stepLengthVariability = %0.16f,\n',...
                            'stepTimeVariability = %0.16f,\n',...
                            'stepLengthAsymmetry = %0.16f,\n',...
                            'stepTimeAsymmetry = %0.16f,\n',...
                            'meanStepVelocity = %0.16f\n',...
                            ')'),...
                            outcomes(1), ...
                            outcomes(2), ...
                            outcomes(5), ...
                            outcomes(8), ...
                            outcomes(9), ...
                            outcomes(10), ...
                            outcomes(11),...
                            outcomes(12));

if nargout < 1
    disp(kotlinStr);
end
end
