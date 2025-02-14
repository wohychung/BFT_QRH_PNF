function plot_E(coor, f, plot_fidx, E)
    x = coor(1,:,1);
    y = coor(:,1,2);
    nx = length(x);
    ny = length(y);
    x = reshape(x, [nx, 1]);
    y = reshape(y, [ny, 1]);
    z = dB20(E(:,:,plot_fidx));

    imagesc(x, y, z);

    xlabel("x (m)");
    ylabel("y (m)");
    title(sprintf('E-Field Magnitude @ %d GHz (dB20)', f(plot_fidx)/1e9));
    colorbar;
    colormap turbo;
end