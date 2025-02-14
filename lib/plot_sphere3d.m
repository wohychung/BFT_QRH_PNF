function plot_sphere3d(r)
  sphere3d( ...
    dB20(r)-max(max(dB20(r'))), ...
    0, pi, -pi/2, pi/2, 1, 1, 'surf', 'spline' ...
    );
end