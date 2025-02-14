function [r_max_theta, r_max_phi, r_max] = get_spherical_maximum(theta, phi, r)
  [r_max, idx] = max(r(:));
  [idx1, idx2] = ind2sub(size(r), idx);
  
  r_max_theta = theta(1, idx2);
  r_max_phi = phi(idx1, 1);
end
