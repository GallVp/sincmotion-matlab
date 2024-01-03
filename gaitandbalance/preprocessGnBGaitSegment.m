function [accelMLxAPxVert, gyroData]   = preprocessGnBGaitSegment(...
                                            accelData, rotData, gyroData,...
                                            fs, isAndroid)

%% Convert acceleration units to m/sec/sec
accelData                               = accelData .* 9.8;

%% Correct for orientation <X-ML, Y-AP, Z-Verticle>
if isAndroid
    accelMLxAPxVert                     = accelData;
    % Use the quiet period from the initial 2 sec segment as reference
    initialToReference                  = quat2rotm(median(...
                                            rotData(fs+1:(1.5*fs), :)));
    referenceToInitial                  = initialToReference';
    gUser                               = accelMLxAPxVert(1, :);
    zVector                             = -gUser;
    initialToXArbitZVerticle            = gravity2rotm(zVector);
    referenceToXArbitZVerticle          = initialToXArbitZVerticle *...
                                            referenceToInitial;
    
    for i=1:length(accelMLxAPxVert)
        frameToReference                = quat2rotm(rotData(i, :));
        frameToToXArbitZVerticle        = referenceToXArbitZVerticle *...
                                            frameToReference;
        correctedSample                 = frameToToXArbitZVerticle *...
                                            (accelMLxAPxVert(i,:)');
        accelMLxAPxVert(i,:)            = correctedSample;
    end
else
    accelMLxAPxVert = accelData;
    for i=1:length(accelMLxAPxVert)
        rotMat                          = quat2rotm(rotData(i, :));
        correctedSample                 = rotMat*(accelMLxAPxVert(i,:)');
        accelMLxAPxVert(i,:)            = correctedSample;
    end
end

%% If Android: Remove initial 2 seconds
if isAndroid
    accelMLxAPxVert                     = accelMLxAPxVert((2*fs)+1:end, :);
    gyroData                            = gyroData((2*fs)+1:end, :);
end
end

