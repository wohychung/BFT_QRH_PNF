function [D, U_Co, U_Cross, D_Co, D_Cross] = get_directivity(U, TRP, E_theta, E_phi, phi)
    D = 4*pi*U/TRP;
    U_Co = (abs(E_theta.*cos(phi)-E_phi.*sin(phi))).^2;
    U_Cross = (abs(E_theta.*sin(phi)+E_phi.*cos(phi))).^2;
    D_Co = 4*pi*U_Co/TRP;
    D_Cross = 4*pi*U_Cross/TRP;
end