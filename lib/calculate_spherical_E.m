function [E_theta, E_phi] = calculate_spherical_E(FF_H_spherical, FF_V_spherical, theta, phi, FF_coeff)
    E_theta=FF_coeff*(FF_H_spherical.*cos(phi)+FF_V_spherical.*sin(phi));
    E_phi=FF_coeff*cos(theta).*(-FF_H_spherical.*sin(phi)+FF_V_spherical.*cos(phi));
end