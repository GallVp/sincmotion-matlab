function [value, tStride]   = estimateGaitSymIndex(accelMLxAPxVert,...
                                fs, debugFlag)

fs4                         = fs*4;

figure;
arML                        = acf(accelMLxAPxVert(:, 1),...
                                min(fs4, length(accelMLxAPxVert(:, 1))-1));
arAP                        = acf(accelMLxAPxVert(:, 2),...
                                min(fs4, length(accelMLxAPxVert(:, 2))-1));
arVert                      = acf(accelMLxAPxVert(:, 3),...
                                min(fs4, length(accelMLxAPxVert(:, 3))-1));

g = gcf; % Dealing with internals of acf
delete(g);

arML(arML<0)                = 0;
arAP(arAP<0)                = 0;
arVert(arVert<0)            = 0;

cStep                       = sqrt(arML+arAP+arVert);
[locAmps, locs]             = findpeaks(cStep);

% Trying three methods to select the most appropriate peak
cStepLows                   = find(cStep <= 0.25*sqrt(3));
validityStart               = cStepLows(1);

pLocs                       = locs(locs > 2*validityStart);
[~, tStrideAI]              = max(cStep(pLocs));
tStrideA                    = pLocs(tStrideAI);
tStepA                      = round(tStrideA*0.5);

if(tStepA < validityStart)
    valueA                  = 0;
else
    valueA                  = cStep(tStepA) / sqrt(3);
end


atLocB                      = estimateStrideIndex(accelMLxAPxVert(:, 3),...
                                arVert, fs, debugFlag);
[~, tStrideIB]              = min(abs(locs-atLocB));
tStrideB                    = locs(tStrideIB);
tStepB                      = round(tStrideB*0.5);
if(tStepB < validityStart)
    valueB                  = 0;
else
    valueB                  = cStep(tStepB) / sqrt(3);
end

[~, tStrideCI]              = max(locAmps);
tStrideC                    = locs(tStrideCI);
tStepC                      = round(tStrideC*0.5);
if(tStepC < validityStart)
    valueC                  = 0;
else
    valueC                  = cStep(tStepC) / sqrt(3);
end

[maxValue, maxValInd]       = max([valueA valueB valueC]);
tStrideVect                 = [tStrideA tStrideB tStrideC];

if(maxValue == 0)
    tStride                 = max(tStrideVect);
else
    tStride                 = tStrideVect(maxValInd);
end

tStep                       = round(tStride*0.5);
value                       = cStep(tStep) / sqrt(3);

if debugFlag > 2
    figure;
    plot(cStep);
    hold on;plot(tStride, cStep(tStride), 'ro');
    plot(tStep, cStep(tStep), 'kx');
    plot(tStrideA, 0.8, 'k+', 'MarkerSize', 12);
    plot(tStrideB, 0.8, 'k*', 'MarkerSize', 12);
    plot(tStrideC, 0.8, 'k^', 'MarkerSize', 12);
    legend({'Cstep', 'Tstride', 'Tstep'}, 'Interpreter', 'latex');
    hold off;
    title('GSI by three methods')
end

    function strideIndex    = estimateStrideIndex(aVert, arVert, fs,...
                                debugFlag)
        
        [b, a]              = butter(2, 3/(fs/2), 'low');
        filteredData        = filtfilt(b,a, arVert);
        
        [~, possibleLocs]   = findpeaks(filteredData);
        
        cwt_scale           = 16;
        aVertInt            = cumsum(aVert./fs);
        dy                  = diff_cwtft(aVertInt', cwt_scale, 1/fs);
        [~, periodPeaks]    = findpeaks(-dy);
        period              = round(median(diff(periodPeaks))*2);
        
        [~, strideIndexI]   = min(abs(possibleLocs-period));
        strideIndex         = possibleLocs(strideIndexI);
        
        if debugFlag > 2
            figure;
            findpeaks(filteredData);
            hold on;
            plot(strideIndex, filteredData(strideIndex), 'ko');
            hold off;
            title('Stride index estimated by method 2 of GSI')
        end
        
    end
end

