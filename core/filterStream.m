function [filteredData] = filterStream(data, fs, order, fcLow, fcHigh, zeroPhase)
%filterStream Apply low and high pass filter to a stream of data.
%
%   Copyright (c) <2016> <Usman Rashid>
%   Licensed under the MIT License. See License.txt in the project root for
%   license information.

[b, a]  = butter(order, fcLow/(fs/2), 'low');
[bb, aa] = butter(order, fcHigh/(fs/2), 'high');

if(zeroPhase)
    filteredData = filtfilt(b,a, data);
    filteredData = filtfilt(bb,aa,filteredData);
else
    filteredData = filter(b,a, data);
    filteredData = filter(bb,aa,filteredData);
end
