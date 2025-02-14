% Initialization
function [f, nf, coor_list] = initialize_load_dataset(fname, target_path)
    fname_1 = string(fname(1));
    S = loading_snp( ...
        sprintf('%s/%s', target_path, fname_1) ...
    );
    f = S.Fr;
    nf = length(f);
    coor_list = nan([length(fname), 3]);
end