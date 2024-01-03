function [symIndex,...
    stepLengths,...
    leftStepLengths,...
    rightStepLengths,...
    stepTimes,...
    leftStepTimes,...
    rightStepTimes]             = estimateGaitOutcomes(accelMLxAPxVert,...
                                    gyroAboutAP,...
                                    fs, personHeight, debugFlag)

%% Compute outputs

% Symmetry outcomes
[symIndex, tStrideSample]       = estimateGaitSymIndex(accelMLxAPxVert,...
                                    fs, debugFlag);

% Exclude first stride
accelVert                       = accelMLxAPxVert(tStrideSample + 1:end, 3);
accelVert                       = accelVert - mean(accelVert);

gAP                             = gyroAboutAP(tStrideSample + 1:end);

height                          = personHeight; % Meters
halfOfHeight                    = height*0.5;
footLength                      = height*0.16;

% Estimate gait events
[initialContacts, isLeftIC, ~]  = estimateFootEvents(accelVert,...
                                    gAP, fs, debugFlag);

[stepLengths, leftStepLengths,...
    rightStepLengths, ~]        = estimateStepLengths(accelVert,...
                                    halfOfHeight, footLength,...
                                    fs, tStrideSample,...
                                    initialContacts, isLeftIC, debugFlag);

stepTimes                       = diff(initialContacts)./fs;
leftStepTimes                   = stepTimes(isLeftIC(2:end));
rightStepTimes                  = stepTimes(~isLeftIC(2:end));
end

