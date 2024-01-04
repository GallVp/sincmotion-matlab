function accelMLxAPxVert        = preprocessGnBStaticStream(accelData,...
                                    rotData, fs, isAndroid)

%% Convert acceleration units to m/sec/sec
accelData                       = accelData .* 9.8;

%% If Android, discard first 3 seconds of data to avoid transients
if isAndroid
    accelData                   = accelData((3*fs)+1:end, :);
    rotData                     = rotData((3*fs)+1:end, :);
end

%% Correct for orientation <X-ML, Y-AP, Z-Verticle>
if isAndroid
    accelDataRotated            = accelData;
    initialToReference          = quat2rotm(rotData(1, :));
    referenceToInitial          = initialToReference';
    gUser                       = accelDataRotated(1, :);
    zVector                     = -gUser;
    initialToXArbitZVerticle    = gravity2rotm(zVector);
    referenceToXArbitZVerticle  = initialToXArbitZVerticle * referenceToInitial;
    
    for i=1:length(accelDataRotated)
        frameToReference        = quat2rotm(rotData(i, :));
        frameToToXArbitZVerticle= referenceToXArbitZVerticle * frameToReference;
        correctedSample         = frameToToXArbitZVerticle*(accelDataRotated(i,:)');
        accelDataRotated(i,:)   = correctedSample;
    end
else
    accelDataRotated = accelData;
    for i=1:length(accelDataRotated)
        rotMat                  = quat2rotm(rotData(i, :));
        correctedSample         = rotMat*(accelDataRotated(i,:)');
        accelDataRotated(i,:)   = correctedSample;
    end
end


% Filter Data
paddedData                      = [flip(accelDataRotated(1:10*fs, :));...
                                    accelDataRotated;...
                                    flip(accelDataRotated(end-10*fs+1:end, :))];
pFilteredData                   = filterStream(paddedData, fs, 2, 45, 0.3, 1);
accelMLxAPxVert                 = pFilteredData(10*fs+1:end-10*fs, :);
end