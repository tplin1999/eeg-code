% merge pt's FC
function newFC_data = mergeFC(FC_data)
    temp = cell(1,2);
    newFC_data = struct('name', '', 'week', '',...
                'PLV_delta', temp, 'PLV_theta', temp, 'PLV_alpha', temp, 'PLV_beta', temp, ...
                'PLI_delta', temp, 'PLI_theta', temp, 'PLI_alpha', temp, 'PLI_beta', temp, ...
                'wPLI_delta', temp, 'wPLI_theta', temp, 'wPLI_alpha', temp, 'wPLI_beta', temp);
    no = 0;
    for ii = 1 : size(FC_data, 1)
        fileName = FC_data(ii).name;
        splitName = strsplit(fileName,"_");
        newName = splitName(1,1);
        
        if (contains(newName, "C"))
            week = splitName(1,3);
            band = splitName(1,5);
        elseif (contains(newName, "H"))
            week = splitName(1,2);
            band = splitName(1,4);
        end

        if (contains(band,"band 1") || contains(band,"Band 1"))
            no = no + 1;
            newFC_data(no).name = newName;
            newFC_data(no).week = week;
            newFC_data(no).PLV_delta = FC_data(ii).PLV;
            newFC_data(no).PLI_delta = FC_data(ii).PLI;
            newFC_data(no).wPLI_delta = FC_data(ii).wPLI;
        elseif (contains(band,"band 2") || contains(band,"Band 2"))
            newFC_data(no).PLV_theta = FC_data(ii).PLV;
            newFC_data(no).PLI_theta = FC_data(ii).PLI;
            newFC_data(no).wPLI_theta = FC_data(ii).wPLI;
        elseif (contains(band,"band 3") || contains(band,"Band 3"))
            newFC_data(no).PLV_alpha = FC_data(ii).PLV;
            newFC_data(no).PLI_alpha = FC_data(ii).PLI;
            newFC_data(no).wPLI_alpha = FC_data(ii).wPLI;
        elseif (contains(band,"band 4") || contains(band,"Band 4"))
            newFC_data(no).PLV_beta = FC_data(ii).PLV;
            newFC_data(no).PLI_beta = FC_data(ii).PLI;
            newFC_data(no).wPLI_beta = FC_data(ii).wPLI;
        else
            error("file name doesn't contain band number.");
        end
    end
end % end function