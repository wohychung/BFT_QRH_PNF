function plot_spherical_E(E_theta, E_phi)
  subplot(1,2,1);
  plot_sphere3d(E_theta);
  title('|E_{\theta}| (dBi)');
  subplot(1,2,2);
  plot_sphere3d(E_phi);
  title('|E_{\phi}| (dBi)');
end
