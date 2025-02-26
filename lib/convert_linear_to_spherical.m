function data_spherical = convert_linear_to_spherical_complex(data_linear, x, y, k, theta, phi)
%   % For complex interpolation
%   data_spherical = interp2( ...
%     y, ...
%     x, ...
%     data_linear, ...
%     k*sin(theta).*cos(phi), ...
%     k*sin(theta).*sin(phi) ...
%   );

%   % For Mag interpolation
%   data_spherical = interp2( ...
%     y, ...
%     x, ...
%     abs(data_linear), ...
%     k*sin(theta).*cos(phi), ...
%     k*sin(theta).*sin(phi) ...
%   );

  % For Mag/Phase interpolation
  data_spherical_mag = interp2( ...
    y, ...
    x, ...
    abs(data_linear), ...
    k*sin(theta).*cos(phi), ...
    k*sin(theta).*sin(phi) ...
  );

  data_linear_phase = angle(data_linear);
  data_spherical_phase = interp2_unwrap( ...
    y, ...
    x, ...
    data_linear_phase, ...
    k*sin(theta).*cos(phi), ...
    k*sin(theta).*sin(phi) ...
  );
  
  data_spherical = data_spherical_mag .* exp(1j .* data_spherical_phase);
end
