% For each s2p file, extract the coordinates from the filename
% and load the s2p data
function [coor_list, s2p_list] = extract_coordinates_and_load_s2p(fname, coor_list, target_path, f)
    for i = 1:length(fname)
        fname_i = string(fname(i));
        fname_i_split = split(erase(fname_i, ".s2p"), "_");
        coor_list(i,:) = str2double(fname_i_split);
        S = loading_snp( ...
            sprintf('%s/%s', target_path, fname_i) ...
        );
        s2p_list(i) = S2P( ...
            f, ... % freq
            S.Param(:,1), ... % S11
            S.Param(:,3), ... % S12
            S.Param(:,2), ... % S21
            S.Param(:,4), ... % S22
            50, ... % Zs
            50, ... % Zl
            50 ... % Z0
        );
    end
end
