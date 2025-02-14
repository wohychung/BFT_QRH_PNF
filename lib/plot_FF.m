function plot_FF(phase_grid, f, plot_fidx, FF)
    x = phase_grid(1,:,1);
    y = phase_grid(:,1,2);
    nx = length(x);
    ny = length(y);
    x = reshape(x, [nx, 1]);
    y = reshape(y, [ny, 1]);
    z = dB20(FF(:,:));

    imagesc(x, y, z);

    xlabel("x (m)");
    ylabel("y (m)");
    title(sprintf('E-Field Magnitude @ %d GHz (dB20)', f(plot_fidx)/1e9));
    colorbar;
    colormap turbo;
end