% Rebuild the scanning plane from the measurement data
function [x_axis, y_axis, dx, dy] = rebuild_scanning_plane(coor_list)
    x_axis = unique(coor_list(:,1));
    y_axis = unique(coor_list(:,2));
    
    x_axis = sort(x_axis, 'ascend');
    y_axis = sort(y_axis, 'ascend');

    dx = x_axis(2) - x_axis(1);
    dy = y_axis(2) - y_axis(1);
end