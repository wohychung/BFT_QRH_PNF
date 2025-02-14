function [coor, f, s2p, x_axis, y_axis, nx, ny, dx, dy] = load_dataset(target_path)
    % Identify s2p files inside the directory
    fname = ls(sprintf('%s/*.s2p', target_path));

    % Convert to cell for string processing
    fname = cellstr(fname);

    % Initialization
    [f, nf, coor_list] = initialize_load_dataset(fname, target_path);

    % For each s2p file, extract the coordinates from the filename
    % and load the s2p data
    [coor_list, s2p_list] = extract_coordinates_and_load_s2p(fname, coor_list, target_path, f);

    % Rebuild the scanning plane from the measurement data
    [x_axis, y_axis, dx, dy] = rebuild_scanning_plane(coor_list);
    
    % Assign coordinates to coor
    [nx, ny, coor] = assign_coordinates(x_axis, y_axis);

    % Assign each 2-port S-paramater data to s2p
    s2p = assign_s2p(nx, ny, coor_list, x_axis, y_axis, s2p_list);
end
