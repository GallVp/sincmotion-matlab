function [stepLengths,...
    leftStepLengths, rightStepLengths,...
    distance]               = estimateStepLengths(aVert,...
                                halfOfHeight, footLength, fs,...
                                tStride, initialContacts, isLeftIC,...
                                debugFlag)

OPTIMAL_K                   = 0.584830;

v                           = cumsum(-aVert./fs);
v                           = v - movmean(v, tStride);
dp                          = cumsum(v./fs);
dp                          = dp - movmean(dp, tStride);
d_appended                  = [flip(dp);dp;flip(dp)];
d_appended                  = filterStream(d_appended, fs, 2, 45, 0.1, 1);
d                           = d_appended(length(dp) + 1 : end - length(dp));

leftICs                     = initialContacts(isLeftIC);
rightICs                    = initialContacts(~isLeftIC);

if debugFlag
    figure
    plot(d)
    hold on;
    plot(leftICs, d(leftICs), 'bo');
    plot(rightICs, d(rightICs), 'ro');
    hold off;
    xlabel('Sample no.');
    ylabel('Vertical displacement m/sec/sec');
    title('Vertical displacement with ICs (blue - left)')
end


hs                          = ones(1, length(initialContacts)-1);
hsLeft                      = [];
hsRight                     = [];

for i=2:length(initialContacts)
    dValues                 = d(initialContacts(i-1):initialContacts(i));
    hs(i-1)                 = max(dValues) - (dValues(1) + dValues(end))/2;

    if isLeftIC(i)
        hsLeft              = [hsLeft, hs(i-1)];
    else
        hsRight             = [hsRight, hs(i-1)];
    end
end

stepLengths                 = 2.*sqrt(2.*halfOfHeight.*hs-hs.^2)...
                                + OPTIMAL_K.*footLength;
leftStepLengths             = 2.*sqrt(2.*halfOfHeight.*hsLeft-hsLeft.^2)...
                                + OPTIMAL_K.*footLength;
rightStepLengths            = 2.*sqrt(2.*halfOfHeight.*hsRight-hsRight.^2)...
                                + OPTIMAL_K.*footLength;

distance                    = sum(stepLengths) + 2*median(stepLengths);

if iscolumn(stepLengths)
    stepLengths             = stepLengths';
    leftStepLengths         = leftStepLengths';
    rightStepLengths        = rightStepLengths';
end
end
