function vq = interp2_unwrap(x,y,v,xq,yq)
  vq = zeros(size(xq));
  x_axis = x(1,:);
  y_axis = y(:,1);
  for i = 1:size(xq,1)
    for j = 1:size(xq,2)
      xqij = xq(i,j);
      yqij = yq(i,j);

      if xqij == x_axis(1)
        xqij_idx = 2;
      elseif xqij == x_axis(end)
        xqij_idx = length(x_axis);
      else
        xqij_idx = find(sort([x_axis, xqij]) == xqij, 1);
      end

      if yqij == y_axis(1)
        yqij_idx = 2;
      elseif yqij == y_axis(end)
        yqij_idx = length(y_axis);
      else     
        yqij_idx = find(sort([y_axis; yqij]) == yqij, 1);
      end

      x_local = x(yqij_idx-1:yqij_idx, xqij_idx-1:xqij_idx);
      y_local = y(yqij_idx-1:yqij_idx, xqij_idx-1:xqij_idx);
      v_local = v(yqij_idx-1:yqij_idx, xqij_idx-1:xqij_idx);
      v_local = unwrap(unwrap(v_local, [], 1), [], 2);
      vq(i,j) = interp2(x_local,y_local,v_local,xqij,yqij);
    end
  end
end