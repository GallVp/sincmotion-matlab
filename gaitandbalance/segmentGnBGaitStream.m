function [accelSegments,...
    rotSegments,...
    gyroSegments]   = segmentGnBGaitStream(timeVect,...
    accelData, rotData, gyroData)

%% Create four segments of data using timeVect
startsAt            = find(diff(timeVect) > 1);

accelSegments       = {accelData(1:startsAt(1), :),...
                        accelData(startsAt(1) + 1:startsAt(2), :),...
                        ... % +1 to go to first sample of the lap
                        accelData(startsAt(2) + 1:startsAt(3), :),...
                        accelData(startsAt(3) + 1:end, :)};

rotSegments         = {rotData(1:startsAt(1), :),...
                        rotData(startsAt(1) + 1:startsAt(2), :),...
                        rotData(startsAt(2) + 1:startsAt(3), :),...
                        rotData(startsAt(3) + 1:end, :)};

gyroSegments        = {gyroData(1:startsAt(1), :), ...
                        gyroData(startsAt(1) + 1:startsAt(2), :),...
                        gyroData(startsAt(2) + 1:startsAt(3), :),...
                        gyroData(startsAt(3) + 1:end, :)};
end
