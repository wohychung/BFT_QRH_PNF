function s2p = create_dummy_s2p(nx, ny, f)
    nf = length(f);
    for ix = 1:nx
        for iy = 1:ny
            s2p(iy, ix) = S2P( ...
                f, ... % freq
                ones([nf, 1])*1e-100, ... % S11
                ones([nf, 1])*1e-100, ... % S12
                ones([nf, 1])*1e-100, ... % S21
                ones([nf, 1])*1e-100, ... % S22
                50, ... % Zs
                50, ... % Zl
                50 ... % Z0
            );
        end
    end
end
