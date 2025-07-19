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
paddingSeconds                  = min(10, floor(height(accelData)/fs));
paddedData                      = [flip(filteredAccelMLxAPxVert(1:paddingSeconds*fs, :));...
                                    filteredAccelMLxAPxVert;...
                                    flip(filteredAccelMLxAPxVert(end-paddingSeconds*fs+1:end, :))];
pFilteredData                   = filterStream(paddedData, fs, 2, 45, 0.3, 1);
filteredAccelMLxAPxVert         = pFilteredData(paddingSeconds*fs+1:end-paddingSeconds*fs, :);
end
