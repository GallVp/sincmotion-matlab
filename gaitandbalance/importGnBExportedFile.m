function fileData = importfilePostQuat(filename, dataLines)
%IMPORTFILE Import data from a text file
%  fileData = IMPORTFILE(FILENAME) reads
%  data from text file FILENAME for the default selection.  Returns the
%  numeric data.
%
%  fileData = IMPORTFILE(FILE, DATALINES)
%  reads data for the specified row interval(s) of text file FILENAME.
%  Specify DATALINES as a positive scalar integer or a N-by-2 array of
%  positive scalar integers for dis-contiguous row intervals.
%
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 08-Jan-2020 11:18:42

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Timestamp", "AccelX", "AccelY", "AccelZ", "GyroX", "GyroY", "GyroZ", "QuatW", "QuatX", "QuatY", "QuatZ"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

opts = opts.setvaropts('Timestamp', 'DatetimeFormat', 'yyyy-MM-dd HH:mm:ss.SSSS');

% Specify file level properties
opts.ExtraColumnsRule = "ignore";

% Import the data
fileData = readtable(filename, opts);
end
