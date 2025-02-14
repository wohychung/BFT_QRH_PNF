function [H, f, x, y, dx, dy, nx, ny, coor] = load_pnf(fname)
  fid = fopen(fname);
  str = fgetl(fid);
  nf = str2num(fgetl(fid));
  str = fgetl(fid);
  f = str2num(fgetl(fid)) * 1e9;
  str = fgetl(fid);
  scanmode = fgetl(fid);
  str = fgetl(fid);
  dist = str2num(fgetl(fid))/1000;
  str = fgetl(fid);
  yscan = str2num(fgetl(fid))/1000;
  str = fgetl(fid);
  xscan = str2num(fgetl(fid))/1000;
  
  dx = xscan(3); % Sample spacing in the x direction [m]
  dy = yscan(3); % Sample spacing in the y direction [m]
  x = xscan(1):dx:xscan(2) % x y scan of circuar aperture
  y = yscan(1):dy:yscan(2);
  
  nx = length(x);
  ny = length(y);
  
  H = zeros(ny,nx);
  for k=1:nx
    tmp = str2num(fgetl(fid));
    H(:,k) = tmp(1:2:end-1) + i*tmp(2:2:end);
  end
  
  for ix = 1:nx
    for iy = 1:ny
      coor(iy, ix, :) = [x(ix), y(iy)];
    end
  end
end