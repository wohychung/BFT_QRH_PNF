function plot_spherical(theta, phi, r)
    x_sph = sin(theta).*cos(phi);
    y_sph = sin(theta).*sin(phi);
    z_sph = cos(theta);
    polar([0 2*pi], [0 1])
    hold on
    surf(x_sph, y_sph, z_sph, r, 'EdgeAlpha', 0)
    hold off
    colorbar
end
