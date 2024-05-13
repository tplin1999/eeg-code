% calculate one channel's power and return 4 band's power
function [TFDelta, TFTheta, TFAlpha, TFBeta] = tfaMorlet(td, fs, fmin, fmax, fstep)
    TFDelta = []; TFTheta = []; TFAlpha = []; TFBeta = [];
    for fc=fmin:fstep:fmax
        MW = MorletWavelet(fc/fs);  % calculate the Morlet Wavelet by giving the central freqency
        cr = conv(td, MW, 'same');
        if(fc <= 4)
            TFDelta = [TFDelta; cr'];
        elseif(fc <= 8)
            TFTheta = [TFTheta; cr'];
        elseif(fc <= 13)
            TFAlpha = [TFAlpha; cr'];
        elseif(fc <= 30)
            TFBeta = [TFBeta; cr'];
        end
    end
end
% calculate morlet wavelet function
function MW = MorletWavelet(fc)
    F_RATIO = 7;    % frequency ratio (number of cycles): fc/sigma_f, should be greater than 5
    Zalpha2 = 3.3;  % value of Z_alpha/2, when alpha=0.001
    
    sigma_f = fc/F_RATIO;
    sigma_t = 1/(2*pi*sigma_f);
    A = 1/sqrt(sigma_t*sqrt(pi));
    max_t = ceil(Zalpha2 * sigma_t);
    
    t = -max_t:max_t;
    
    %MW = A * exp((-t.^2)/(2*sigma_t^2)) .* exp(2i*pi*fc*t);
    v1 = 1/(-2*sigma_t^2);
    v2 = 2i*pi*fc;
    MW = A * exp(t.*(t.*v1+v2));
end