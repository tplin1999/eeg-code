% calculate relative power from absolute power
function [RP_delta, RP_theta, RP_alpha, RP_beta] = calRP(AP_delta, AP_theta, AP_alpha, AP_beta)
    channelNum = size(AP_delta, 2);
    RP_delta = zeros(1,channelNum);
    RP_theta = RP_delta; RP_alpha = RP_delta; RP_beta = RP_delta;

    for ii = 1 : channelNum
        sum4Band = AP_delta(1,ii)+AP_theta(1,ii)+AP_alpha(1,ii)+AP_beta(1,ii);
        RP_delta(1,ii) = AP_delta(1,ii) / sum4Band;
        RP_theta(1,ii) = AP_theta(1,ii) / sum4Band;
        RP_alpha(1,ii) = AP_alpha(1,ii) / sum4Band;
        RP_beta(1,ii) = AP_beta(1,ii) / sum4Band;
    end
end % end function