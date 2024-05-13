%{
1. downsample
2. cut start & end
2. calculate FC(PLV, PLI, wPLI) for eeg data
%}
function [plv, pli, wpli] = calFC(data, fs_og, fs_target, stTime, edTime)
    % downsample
    data = downsample(data, floor(fs_og/fs_target));
    % cut start & end
    data = data((stTime*fs_target+1):(edTime*fs_target), :);

    channelNums = size(data, 2);
    pointNums = size(data, 1);
    plv = zeros(channelNums);
    pli = zeros(channelNums);
    wpli = zeros(channelNums);
    
    for m = 1 : channelNums
        for n = 1 : channelNums
            channel1 = data (:,m);                
            channel2 = data (:,n);
            analytic1  = hilbert (channel1);  
            analytic2 = hilbert (channel2);
    
            phase1 = angle (analytic1);
            phase2 = angle (analytic2);
            CSD = analytic1.*conj(analytic2);
    
            plv(m,n) = abs( sum( exp(1i.*(phase1 - phase2)) ) /pointNums );
            pli(m,n) = abs( sum( sign(imag( exp(1i.*(phase1 - phase2)) )) ) /pointNums );
            
            wpli_top = abs( sum( abs(imag(CSD)) .* sign(imag(CSD)) ) /pointNums );
            wpli_bot = sum( abs(imag(CSD)) ) /pointNums;
            if (wpli_bot==0)
                wpli(m,n) = 0;
            else
                wpli(m,n) = wpli_top / wpli_bot;
            end
        end
    end
end