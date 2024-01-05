function accelMLxAPxVert            = applyGnBFrameCorrection(accelData,...
                                        rotData, fs, isAndroid)
if isAndroid
    accelMLxAPxVert                 = accelData;
    % Use the quiet period from the initial 2 sec segment as reference
    initialToReference              = quat2rotm(median(...
                                        rotData(fs+1:(1.5*fs), :)));
    referenceToInitial              = initialToReference';
    gUser                           = accelMLxAPxVert(1, :);
    zVector                         = -gUser;
    initialToXArbitraryZVertical    = androidGravity2RotMat(zVector);
    referenceToXArbitraryZVertical  = initialToXArbitraryZVertical *...
                                        referenceToInitial;
    
    for i=1:length(accelMLxAPxVert)
        frameToReference            = quat2rotm(rotData(i, :));
        frameToXArbitraryZVertical  = referenceToXArbitraryZVertical *...
                                        frameToReference;
        correctedSample             = frameToXArbitraryZVertical *...
                                        (accelMLxAPxVert(i,:)');
        accelMLxAPxVert(i,:)        = correctedSample;
    end
else
    accelMLxAPxVert                 = accelData;
    for i=1:length(accelMLxAPxVert)
        rotMat                      = quat2rotm(rotData(i, :));
        correctedSample             = rotMat*(accelMLxAPxVert(i,:)');
        accelMLxAPxVert(i,:)        = correctedSample;
    end
end
end