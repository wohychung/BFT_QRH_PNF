function [FF_H, FF_V, FF_Z] = calculate_farfield(E_H, E_V, target_fidx, nx, ny, nx2, ny2, x2_grid, y2_grid, z2_grid)
    E2_H = reshape(E_H(:,:,target_fidx), [nx, ny]);
    E2_V = reshape(E_V(:,:,target_fidx), [nx, ny]);
    
    FF_H = ifftshift(ifft2(E2_H, nx2, ny2));
    FF_V = ifftshift(ifft2(E2_V, nx2, ny2));
    FF_Z=-(FF_H.*x2_grid+FF_V.*y2_grid)./z2_grid;
end