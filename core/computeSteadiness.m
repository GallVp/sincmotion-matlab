function [steadinessML,...
    steadinessAP, steadinessR]  = computeSteadiness(accelMLxAPxVert)

steadinessML                    = -log(mean(abs(accelMLxAPxVert(:, 1))));
steadinessAP                    = -log(mean(abs(accelMLxAPxVert(:, 2))));

resultantVect                   = sqrt((accelMLxAPxVert.^2)*ones(3,1));
steadinessR                     = -log(mean(abs(resultantVect)));
end

