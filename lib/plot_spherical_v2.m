function plot_spherical_v2(theta, phi, r)
  r(r<0) = 0;
  M = max(r, [], 'all');
  x_sph = r.*sin(theta).*cos(phi);
  y_sph = r.*sin(theta).*sin(phi);
  z_sph = r.*cos(theta);
  polar([0 2*pi], [0 M], '--')
  hold on
  surf(x_sph, y_sph, z_sph, r, 'EdgeAlpha', 0)
  hold off
  xlim([-M M])
  ylim([-M M])
  zlim([-M M])
  colorbar
end
