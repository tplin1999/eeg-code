% read set and calculate fc
function [PLV, PLI, wPLI] = readSetCalFC(setPath, fsTarget, stTime, edTime)
    % read eeg data
    [data, fs, ~] = readSET(setPath);
    % calculate FC (all)
    [PLV, PLI, wPLI] = calFC(data, fs, fsTarget, stTime, edTime);
    PLV = getTopTriangle(PLV);
    PLI = getTopTriangle(PLI);
    wPLI = getTopTriangle(wPLI);
end
% get top triangle and turn into vector
function vector = getTopTriangle(matrix)
    At = matrix';
    m = tril(true(size(matrix)), -1);
    vector = At(m);
    vector = vector';
end % end function