function [U, TRP, W] = calculate_TRP(theta, phi, dth, dph, E_theta, E_phi)
    e_theta = [1 4 repmat([2 4], 1, floor(length(theta(1,:))/2) - 1) 1];
    e_phi = [1 4 repmat([2 4], 1, floor(length(phi(:,1))/2) - 1) 1];
    U = (abs(E_theta).^2 + abs(E_phi).^2);
    TRP = dph*dth*sum(sum(U.*(e_theta'*e_phi).*abs(sin(theta))))/9;
		W = 1/(2*120*pi).*(E_theta.*conj(E_theta)+E_phi.*conj(E_phi));
end
