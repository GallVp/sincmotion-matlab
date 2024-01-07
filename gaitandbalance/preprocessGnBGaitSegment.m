function [accelMLxAPxVert,...
    gyroData]                   = preprocessGnBGaitSegment(...
                                    accelData, rotData, gyroData,...
                                    fs, isAndroid)

%% Convert acceleration units to m/sec/sec
accelData                       = accelData .* 9.8;

%% Correct for orientation <X-ML, Y-AP, Z-Verticle>
accelMLxAPxVert                 = applyGnBFrameCorrection(accelData,...
                                    rotData, fs, isAndroid);

%% If Android: Remove initial 2 seconds
if isAndroid
    accelMLxAPxVert             = accelMLxAPxVert((2*fs)+1:end, :);
    gyroData                    = gyroData((2*fs)+1:end, :);
end
end
