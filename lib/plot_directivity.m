function plot_directivity(theta, phi, D_Co, D_Cross)
  subplot(1,2,1); plot_spherical(theta, phi, D_Co)
  title('Ludwig-3 Co-Pol. Dir. (dB)')
  
  subplot(1,2,2); plot_spherical(theta, phi, D_Cross)
  title('Ludwig-3 Cross-Pol. Dir. (dB)')
end