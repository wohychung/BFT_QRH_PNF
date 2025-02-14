function planar_NF = load_measdata(planar_NF, measdata_path)
  load(measdata_path)
  planar_NF.E_V = E_V;
  planar_NF.E_H = E_H;
  planar_NF.f = f;
  planar_NF.fi = fi;
  planar_NF.x = x;
  planar_NF.y = y;
  planar_NF.dx = dx;
  planar_NF.dy = dy;
  planar_NF.nx = nx;
  planar_NF.ny = ny;
  planar_NF.coor = coor;
end