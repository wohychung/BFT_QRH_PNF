function s2p = assign_s2p(nx, ny, coor_list, x_axis, y_axis, s2p_list)
    for ix = 1:nx
        for iy = 1:ny
            s2p(ix, iy) = S2P();
        end
    end
    for i = 1:size(coor_list,1)
        s2p(x_axis == coor_list(i,1), ...
            y_axis == coor_list(i,2) ...
        ) = s2p_list(i);
    end
end