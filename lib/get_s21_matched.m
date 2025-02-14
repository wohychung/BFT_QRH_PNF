%% Compensate impedance mismatch
function s21_matched = get_s21_matched(s2p, fidx)
	nx = size(s2p, 2);
	ny = size(s2p, 1);
	s21_matched = nan([ny, nx]);
	for ix = 1:nx
		for iy = 1:ny
			s2p(iy, ix) = s2p(iy, ix).get_MAG();
			s21_matched(iy, ix) = s2p(iy, ix).MAG(fidx);
		end
	end
end
