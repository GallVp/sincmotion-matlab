%% Setup

clear
close all
clc

%% Constants
FS                              = 100;
IS_ANDROID                      = 0;                % ANDROID=1, else IOS

%% Load data
[accelData,...
    rotData,...
    timeVect,...
    gyroData]                   = loadGnBExportedFile(FS);

%% Plot data
plot(timeVect(1:length(accelData)), detrend(accelData))
ylabel('Acceleration (g/sec/sec)')
title('Detrended raw data')

%% Compute and print outcomes
[outcomes, outcomeString]       = estimateGnBStaticOutcomes(accelData,...
                                    rotData, FS, IS_ANDROID);

disp(outcomeString)