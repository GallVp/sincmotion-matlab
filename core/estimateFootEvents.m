function [initialContacts,...
    isLeftIC, finalContacts]    = estimateFootEvents(aVert, gAP, fs,...
                                    debugFlag)

cwt_scale                       = 16;
aVertInt                        = cumsum(aVert./fs);
dy                              = diff_cwtft(aVertInt', cwt_scale, 1/fs);
dyy                             = diff_cwtft(dy, cwt_scale, 1/fs);
gAPSmooth                       = lowPassStream(gAP, fs, 2);
[~, initialContacts]            = findpeaks(-dy);

% ICs(ICs < fs/4) = [];

[~, finalContacts]              = findpeaks(dyy);

isLeftIC                        = gAPSmooth(initialContacts) < 0;

% Detect anamoly in isLeftIC and apply pattern based correction.

if(sum(abs(diff(isLeftIC)))     ~= (length(isLeftIC) - 1))
    warning('Consecutive ICs are not from opposite sides. Applying pattern based correction.');
    candidateA                  = repmat([1;0], 20, 1);
    candidateB                  = repmat([0;1], 20, 1);

    candidateA                  = candidateA(1:length(isLeftIC));
    candidateB                  = candidateB(1:length(isLeftIC));

    errorA                      = sqrt(sum((candidateA - isLeftIC).^2));
    errorB                      = sqrt(sum((candidateB - isLeftIC).^2));

    if errorA < errorB
        isLeftIC                = candidateA == 1;
    else
        isLeftIC                = candidateB == 1;
    end
end

leftICs                         = initialContacts(isLeftIC);
rightICs                        = initialContacts(~isLeftIC);

if debugFlag > 1
    figure
    plot(aVert, 'Color', [0, 0.4470, 0.7410]);
    hold on;
    plot(leftICs, aVert(leftICs), 'bo');
    plot(rightICs, aVert(rightICs), 'ro');
    plot(finalContacts, aVert(finalContacts), 'kx');
    plot(gAPSmooth./peak2peak(gAPSmooth).*peak2peak(aVert),...
        'Color', [0.8500, 0.3250, 0.0980]);
    hold off;
    xlabel('Sample no.');
    ylabel('Vertical acceleration m/sec/sec');
    title('ICs (o) and FCs (x)')
end
end
