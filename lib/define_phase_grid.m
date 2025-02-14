function [x2, y2, x2_grid, y2_grid, z2_grid, nx2, ny2, phase_grid] = define_phase_grid(zero_padding_order, nx, ny, dx, dy, k)
    nx2 = zero_padding_order * nx;
    ny2 = zero_padding_order * ny;
    
    x2 = linspace(-pi, pi, nx2+1);
    x2 = x2(1:end-1)/dx;
    
    y2 = linspace(-pi, pi, ny2+1);
    y2 = y2(1:end-1)/dy;
    
    [y2_grid, x2_grid] = meshgrid(y2, x2);
    phase_grid(:,:,1) = x2_grid;
    phase_grid(:,:,2) = y2_grid;
    
    z2_grid = sqrt(k^2 - x2_grid.^2 - y2_grid.^2);
end