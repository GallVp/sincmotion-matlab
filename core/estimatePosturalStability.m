function [stabilityR,...
    stabilityML, stabilityAP]   = estimatePosturalStability(accelMLxAPxVert)

stabilityML                     = -log(mean(abs(accelMLxAPxVert(:, 1))));
stabilityAP                     = -log(mean(abs(accelMLxAPxVert(:, 2))));

resultantVect                   = sqrt((accelMLxAPxVert.^2)*ones(3,1));
stabilityR                      = -log(mean(abs(resultantVect)));
end

