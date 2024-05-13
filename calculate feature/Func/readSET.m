% read set file and return 1.Data(channel in specific order), 2.Sample rate, 3.Times
function [OrderData, Srate, Times] = readSET(setPath)
    EEG = pop_loadset(setPath);
    Times = round(EEG.xmax-EEG.xmin);
    Srate = EEG.srate;
    Data = EEG.data;
    Chanlocs = {};
    for i = 1 : length(EEG.chanlocs)
        if(contains(EEG.chanlocs(1,i).labels,"("))
            temp = split(EEG.chanlocs(1,i).labels, ["(", ")"]);
            Chanlocs = cat(1, Chanlocs, temp(2));
        else
            Chanlocs = cat(1, Chanlocs, EEG.chanlocs(1,i).labels);
        end
    end

    OrderData = zeros(19, length(Data));
    ChanOrder = {'Fp1'; 'F3'; 'C3'; 'P3'; 'O1'; 'Fp2'; 'F4'; 'C4'; 'P4';...
                 'O2'; 'F7'; 'T3'; 'T5'; 'F8'; 'T4'; 'T6'; 'Fz'; 'Cz'; 'Pz'};
    for i = 1 : length(ChanOrder)
        I = strcmp(Chanlocs, ChanOrder{i});
        OrderData(i,:) = Data(I,:);
    end
    % need to be transpose because "downsample" function direction
    OrderData = OrderData';
end