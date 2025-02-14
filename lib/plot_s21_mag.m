%% Plot s21 @ specified frequency index (plot_fidx)
function plot_s21_mag(coor, f, plot_fidx, s2p)
    x = coor(1,:,1);
    y = coor(:,1,2);
    nx = length(x);
    ny = length(y);
    x = reshape(x, [nx, 1]);
    y = reshape(y, [ny, 1]);

    z = nan([nx, ny]);
    for ix = 1:nx
        for iy = 1:ny
            z(ix, iy) = dB20(s2p(ix, iy).S(plot_fidx, 2, 1));
        end
    end
    imagesc(x, y, z);

    xlabel("x (m)");
    ylabel("y (m)");
    title(sprintf('mag(S21) @ %d GHz (dB20)', f(plot_fidx)/1e9));
    colorbar;
    colormap turbo;
end