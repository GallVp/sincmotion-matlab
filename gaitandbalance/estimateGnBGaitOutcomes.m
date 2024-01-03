function [outcomes, outcomeString] = estimateGnBGaitOutcomes(timeVect,...
    accelData, rotData, gyroData,...
    fs, personHeight, isAndroid,...
    debugFlag)

%% Create data segments
[accelSegments,...
    rotSegments,...
    gyroSegments]                   = segmentGnBGaitStream(timeVect,...
    accelData, rotData, gyroData);

%% Estimate outcomes for each segment
symIndex                            = NaN .* ones(4, 1);
stepLengths                         = cell(4, 1);
leftStepLengths                     = cell(4, 1);
rightStepLengths                    = cell(4, 1);
stepTimes                           = cell(4, 1);
leftStepTimes                       = cell(4, 1);
rightStepTimes                      = cell(4, 1);

for i = 1:4
    
    % iOS Reference: https://developer.apple.com/documentation/coremotion/getting_processed_device-motion_data/understanding_reference_frames_and_device_attitude
    % Android Reference: https://developer.android.com/guide/topics/sensors/sensors_overview
    [accelMLxAPxVert, gyroData]    = preprocessGnBGaitSegment(...
                                    accelSegments{i},...
                                    rotSegments{i},...
                                    gyroSegments{i},...
                                    fs, isAndroid);
    
    gyroAboutAP                     = gyroData(:, 3);
    % For iOS and Android, Z is the intrinsic AP axis. Counter clock-wise
    % rotations are positive. Thus, positive gyro angles correspond to
    % right swing phase. At the right heel strike the phone is at its
    % counter-clockwise peak.
    
    [symIndex(i), ...
        stepLengths{i},...
        leftStepLengths{i},...
        rightStepLengths{i},...
        stepTimes{i},...
        leftStepTimes{i},...
        rightStepTimes{i}]          = estimateGaitOutcomes(...
                                        accelMLxAPxVert,...
                                        gyroAboutAP,...
                                        fs, personHeight, debugFlag);
end

%% Average across segments
stepCount                           = cellfun(@length, stepLengths);

meanSymIndex                        = median(symIndex) * 100;

meanStepLength                      = median([stepLengths{:}]);
meanStepLengthLeft                  = median([leftStepLengths{:}]);
meanStepLengthRight                 = median([rightStepLengths{:}]);
stdStepLengthLeft                   = iqr([leftStepLengths{:}])/1.35;
stdStepLengtRight                   = iqr([rightStepLengths{:}])/1.35;

meanStepTime                        = median([stepTimes{:}]);
meanStepTimeLeft                    = median([leftStepTimes{:}]);
meanStepTimeRight                   = median([rightStepTimes{:}]);
stdStepTimeLeft                     = iqr([leftStepTimes{:}])/1.35;
stdStepTimeRight                    = iqr([rightStepTimes{:}])/1.35;

    function varPer                 = computeVarPer(leftValues, ...
                                        rightValues, meanValue)
        
        sqSum                       = leftValues^2 + rightValues^2;
        rmsValue                    = sqrt(sqSum / 2);
        varPer                      = rmsValue / meanValue * 100;
    end

    function asymPer                = computeAsymPer(leftValues,...
                                        rightValues, meanValue)
        
        asymPer                     = abs(leftValues - rightValues)...
                                        / meanValue * 100;
    end

stepLengthVariability               = computeVarPer(stdStepLengthLeft,...
                                        stdStepLengtRight, meanStepLength);
stepTimeVariability                 = computeVarPer(stdStepTimeLeft,...
                                        stdStepTimeRight, meanStepTime);

stepLengthASymmetry                 = computeAsymPer(meanStepLengthLeft,...
                                        meanStepLengthRight,...
                                        meanStepLength);
stepTimeASymmetry                   = computeAsymPer(meanStepTimeLeft,...
                                        meanStepTimeRight, meanStepTime);

meanStepVelocity                    = median([stepLengths{:}] ./ [stepTimes{:}]);

stepCountLap1                       = stepCount(1);
stepCountLap2                       = stepCount(2);
stepCountLap3                       = stepCount(3);
stepCountLap4                       = stepCount(4);

%% Create outcomes and description string
outcomes                            = [meanSymIndex,...
                                        meanStepLength, ...
                                        meanStepLengthLeft,...
                                        meanStepLengthRight,...
                                        meanStepTime,...
                                        meanStepTimeLeft,...
                                        meanStepTimeRight,...
                                        stepLengthVariability,...
                                        stepTimeVariability,...
                                        stepLengthASymmetry,...
                                        stepTimeASymmetry,...
                                        meanStepVelocity,...
                                        stepCountLap1,...
                                        stepCountLap2,...
                                        stepCountLap3,...
                                        stepCountLap4];

outcomeString                       = sprintf(strcat(...
                                        'Gait symmetry: %0.16f percent\n',...
                                        'Step length: %0.16f m\n', ...
                                        'Step length (left): %0.16f m\n',...
                                        'Step length (right): %0.16f m\n',...
                                        'Step time: %0.16f sec\n',...
                                        'Step time (left): %0.16f sec\n',...
                                        'Step time (right): %0.16f sec\n',...
                                        'Step length var: %0.16f percent\n',...
                                        'Step time var: %0.16f percent\n',...
                                        'Step length asym: %0.16f percent\n',...
                                        'Step time asym: %0.16f percent\n',...
                                        'Step velocity: %0.16f m/sec\n',...
                                        'Step count lap 1: %d\n',...
                                        'Step count lap 2: %d\n',...
                                        'Step count lap 3: %d\n',...
                                        'Step count lap 4: %d\n'),...
                                        outcomes);
                                        % outcomes(1),...
                                        % outcomes(2),...
                                        % outcomes(3),...
                                        % outcomes(4),...
                                        % outcomes(5),...
                                        % outcomes(6),...
                                        % outcomes(7),...
                                        % outcomes(8),...
                                        % outcomes(9),...
                                        % outcomes(10),...
                                        % outcomes(11),...
                                        % outcomes(12),...
                                        % outcomes(13),...
                                        % outcomes(14),...
                                        % outcomes(15),...
                                        % outcomes(16));
end