function [accelData, rotData, timeVect, gyroData] = loadGnBExportedFile(fs, filePath)


if nargin < 2

    % File selection
    [fileName, folderName]  = uigetfile('*.csv', 'Pick a CSV file exported from innerEar');

    % Load Data
    fileData                = importGnBExportedFile(fullfile(folderName, fileName));

else

    % Load Data
    fileData                = importGnBExportedFile(filePath);
end

% Convert first column to double time vector
fileData.Timestamp          = seconds(fileData.Timestamp - fileData.Timestamp(1)) + 1/fs;

%% Do Preprocessing
accelData                   = [fileData.AccelX fileData.AccelY fileData.AccelZ];

rotData                     = [fileData.QuatW fileData.QuatX fileData.QuatY fileData.QuatZ];
timeVect                    = fileData.Timestamp;

gyroData                    = [fileData.GyroX fileData.GyroY fileData.GyroZ];

end
