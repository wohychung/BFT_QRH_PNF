function [nx, ny, coor] = assign_coordinates(x_axis, y_axis)
    nx = length(x_axis);
    ny = length(y_axis);
    coor = nan([nx,ny,2]);
    for i = 1:nx
        coor(i,:,2) = y_axis;
    end
    for i = 1:ny
        coor(:,i,1) = x_axis;
    end
end