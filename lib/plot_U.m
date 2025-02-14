function plot_U(theta, phi, U_Co, U_Cross)
  subplot(1,2,1); plot_spherical(theta, phi, U_Co)
  title('U\_Co')
  
  subplot(1,2,2); plot_spherical(theta, phi, U_Cross)
  title('U\_Cross')
end