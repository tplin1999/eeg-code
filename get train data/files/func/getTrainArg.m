% this code will list all the combination
function Arg = getTrainArg()
    week = ["W0", "W1", "W1-W0"];
    label = ["W4", "W6", "W8"];
    
    Arg = listComb(week, label);
end
% list all the combination
function comb = listComb(arg1, arg2)
    idx = 1;
    name1 = inputname(1);
    name2 = inputname(2);
    for one = arg1
        for two = arg2
            comb(1,idx) = struct(name1, one, name2, two);
            idx = idx + 1;
        end
    end
end % end function
