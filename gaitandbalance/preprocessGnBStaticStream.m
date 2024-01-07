function filteredAccelMLxAPxVert= preprocessGnBStaticStream(accelData,...
                                    rotData, fs, isAndroid)

%% Convert acceleration units to m/sec/sec
accelData                       = accelData .* 9.8;

%% If Android, discard first 3 seconds of data to avoid transients
if isAndroid
    accelData                   = accelData((3*fs)+1:end, :);
    rotData                     = rotData((3*fs)+1:end, :);
end

%% Correct for orientation <X-ML, Y-AP, Z-Verticle>
filteredAccelMLxAPxVert         = applyGnBFrameCorrection(accelData,...
                                    rotData, fs, isAndroid);

%% Filter Data
paddedData                      = [flip(filteredAccelMLxAPxVert(1:10*fs, :));...
                                    filteredAccelMLxAPxVert;...
                                    flip(filteredAccelMLxAPxVert(end-10*fs+1:end, :))];
pFilteredData                   = filterStream(paddedData, fs, 2, 45, 0.3, 1);
filteredAccelMLxAPxVert         = pFilteredData(10*fs+1:end-10*fs, :);
end
