%% Setup

clear
close all
clc

%% Constants
FS                              = 100;
IS_ANDROID                      = 1;                % ANDROID=1, else IOS
DEBUG_FLAG                      = 0;                % 0, 1, 2, 3
PERSON_HEIGHT                   = 1.68;             % Meters

%% Load data
[accelData,...
    rotData,...
    timeVect,...
    gyroData]                   = loadGnBExportedFile(FS);

%% Plot data
if DEBUG_FLAG > 0
    plot(timeVect(1:length(accelData)), detrend(accelData))
    ylabel('Acceleration (g/sec/sec)')
    title('Detrended raw data')
end

%% Compute and print outcomes
[outcomes, outcomeString]       = estimateGnBGaitOutcomes(timeVect,...
                                    accelData, rotData, gyroData,...
                                    FS, PERSON_HEIGHT, IS_ANDROID,...
                                    DEBUG_FLAG);

disp(outcomeString)