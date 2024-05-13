function newFC = del2ndFile(FC_all)
    fnArr = fieldnames(FC_all)';
    fnArr = setdiff(fnArr, 'name', 'stable');
    fnArr = string(fnArr);
    
    no = 1;
    for fc = FC_all
        if contains(fc.name, "_2")
            continue;
        elseif contains(fc.name, "_1")
            newFC(1, no).name = erase(fc.name, "_1");
        else
            newFC(1, no).name = fc.name;
        end

        for fn = fnArr
            newFC(1, no).(fn) = fc.(fn);
        end

        no = no + 1;
    end
end