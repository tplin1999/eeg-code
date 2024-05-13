%{
1. downsample
2. cut start & end
2. calculate absolute power for eeg data
%}
function [delta, theta, alpha, beta] = calAP(data, fsOg, fsTarget, fmin, fmax, fstep, stTime, edTime)
    % downsample
    data = downsample(data, floor(fsOg/fsTarget));
    chanNum = size(data, 2);
    
    fprintf('calculate PW All.\n');
    delta = zeros(1, chanNum); % get spectrum magnitude
    theta = zeros(1, chanNum); % get spectrum magnitude
    alpha = zeros(1, chanNum); % get spectrum magnitude
    beta = zeros(1, chanNum); % get spectrum magnitude

    data = data((stTime*fsTarget+1):(edTime*fsTarget), :);
    for ii = 1 : chanNum
        [TFDelta, TFTheta, TFAlpha, TFBeta] = tfaMorlet(data(:,ii), fsTarget, fmin, fmax, fstep);
        delta(1, ii) = sum(sum( abs(TFDelta) )); % get spectrum magnitude
        theta(1, ii) = sum(sum( abs(TFTheta) )); % get spectrum magnitude
        alpha(1, ii) = sum(sum( abs(TFAlpha) )); % get spectrum magnitude
        beta(1, ii) = sum(sum( abs(TFBeta) )); % get spectrum magnitude 
    end
end