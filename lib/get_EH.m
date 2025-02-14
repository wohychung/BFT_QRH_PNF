function [E, H] = get_EH(W)
	size(W)
    E = dB(W(floor(size(W, 2)/2),:))-max(dB(W(floor(size(W, 2)/2),:)));
    H = dB(W(1,:))-max(dB(W(1,:)));
end
