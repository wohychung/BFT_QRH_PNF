function [Co] = oeg_Co_calc(a,b,lambda,Eo, gamma)
    N_integral = 500;
	beta_k = sqrt(1.0 - (lambda/(2.0*a)).^2.0);
    kay = 2*pi./lambda;
	beta = beta_k .* kay;
    dpi = pi / real(N_integral - 1);
    
	theta = 0.0;
    DD=0;
    EE=0;
    F1=0;
    for n = 1:N_integral
       gamma1 = gamma;
	   [E_phi_1 E_phi_2 E_theta_1 E_theta_2] = EH_plane_pattern (a,b,kay, Eo, theta,gamma1);
	   DD = DD + (abs(E_theta_2.^2.0)+abs(E_phi_2.^2.0)).*sin(theta);
	   EE = EE + real(E_theta_1.*conj(E_theta_2) + E_phi_1  .*conj(E_phi_2  )).*sin(theta);
	   F1 = F1 + (abs(E_theta_1.^2.0)+abs(E_phi_1.^2.0)).*sin(theta);
	   theta = theta + dpi
    end
	DD = DD*dpi;
	EE = EE*dpi;
	F1 = F1*dpi;
	F2 = - a*b*Eo.*Eo.*beta.*kay/(2.0*pi).*(1.0 - (abs(gamma)).^2.0);
	FF = F1 + F2;
	if ((EE.*EE-DD.*FF) < 0.0) 
		disp('*** Error : EE*EE-DD*FF < 0 in Subroutune Co_factor');
    end

	Co_plus  = ( -EE + sqrt(EE.*EE-DD.*FF) ) ./ DD;
	Co_minus = ( -EE - sqrt(EE.*EE-DD.*FF) ) ./ DD;

	Co = Co_plus;
	%Check of Co
    Error_Co = DD.*Co.*Co + 2*EE.*Co + FF;
    Power_radiated = pi ./ (2*120*pi*kay.*kay);
 	Power_radiated = Power_radiated .* (DD.*Co.*Co + 2*EE.*Co + F1);
end

function [E_phi_1 E_phi_2 E_theta_1 E_theta_2] = EH_plane_pattern (a,b,kay, Eo, theta,gamma)
	%	Calculation of 1) eq. (7) : far-field H-plane pattern of OEG
	%                    2) eq. (8) : far-field E-plane pattern of OEG
    lambda = 2*pi./kay;
	beta_k = sqrt(1.0 - (lambda/(2.0*a)).^2);

	A_phi = -i.*kay.^2*a*b.*Eo/8.0;

	E_phi_1 = cos(theta) + beta_k;
	E_phi_1 = E_phi_1 + gamma.*(cos(theta) - beta_k);
	E_phi_1 = E_phi_1 ./ ((pi/2.0)^2.0-(kay*a.*sin(theta)/2.0).^2.0);
	E_phi_1 = E_phi_1.*cos(kay*a.*sin(theta)/2.0);
	E_phi_1 = A_phi.*E_phi_1;

	E_phi_2 = A_phi.*cos(kay*a.*sin(theta)/2.0);

    %E-plane pattern : eq (8)
    %when clac E at forward hemispher set gamma to zero
	if ( (theta >= -pi/2) & (theta <= pi/2) ) 
        gamma=0; 
    end

	com = 1.0 + beta_k.*cos(theta) + gamma.*(1.0 - beta_k.*cos(theta));
	com = com ./ (1.0 + beta_k + gamma.*(1.0 - beta_k));
	if ( abs(theta) > 0.00001)
	   com = com .* sin(kay*b.*sin(theta)/2.0)./(kay*b.*sin(theta)/2.0);
    end;

	E_theta_1 = 1.0 + beta_k + gamma.*(1.0 - beta_k);	%eq (9)
	E_theta_1 = E_theta_1*(2.0/pi)^2.0;
	E_theta_1 = E_theta_1.*A_phi.*com;

	E_theta_2 = A_phi.*com;
end
