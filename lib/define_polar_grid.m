function [theta, phi] = define_polar_grid(dth, dph)
    % theta = -pi/2 + dth : dth : pi/2 - dth;
    % phi = 0 + dph : dph : pi - dph;
    theta = -pi/2: dth : pi/2;
    phi = 0: dph : pi;
    [theta, phi] = meshgrid(theta, phi);
end
