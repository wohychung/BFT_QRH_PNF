% !	References
% !	   2) A. D. Yaghjian,
% !               "Approximate formulas for the far field and gain of
% !                open-ended rectangular waveguide",
% !                IEEE Trans. Antennas Propagat.,
% !                Vol. AP-32, No. 4, pp. 378-384, Apr. 1984.

function [Etheta Ephi] = oeg_pattern(freq, a, b, gamma,theta, phi)
    c0=299792458;  % Speed of light in vacuum [m/s]
    mu0 = 4.0e-7 * pi;
	ep0 = 1.0 / (mu0*c0*c0);
    er_air = 1.000649;
    
    lambda = c0/freq/sqrt(er_air);
    kay = 2*pi/lambda;
    Power_input = 10; %[W]
	%Calculation of Magnitude of TE10 mode : Eo
    beta_k = sqrt(1-(lambda/(2*a))^2);
    Eo = Power_input*4.0*sqrt(mu0/ep0/er_air);
    Eo = Eo / (a*b*(1.0-(abs(gamma)^2.0))*beta_k);
    Eo = sqrt(Eo);
    Co = oeg_Co_calc(a,b,lambda,Eo, gamma)
    
    [TH PHI]=meshgrid(theta, phi);
    [Etheta Ephi] = oeg_cal_pattern(TH, PHI, kay, a, b, Eo, Co, gamma);
    
end

function [E_theta E_phi] = oeg_cal_pattern(theta, phi, kay, a, b, Eo, Co, gamma)
    %Calculation of 1) eq. (7) : far-field H-plane pattern of OEG
	%               2) eq. (8) : far-field E-plane pattern of OEG
    lambda = 2*pi/kay;
	beta_k = sqrt(1.0 - (lambda/(2.0*a))^2.0);
	A_phi = -i*kay^2*a*b*Eo / 8.0;
    %H-plane pattern : eq (7)
	E_phi_1 = cos(theta) + beta_k;
	E_phi_1 = E_phi_1 + gamma*(cos(theta) - beta_k);
	E_phi_1 = E_phi_1 ./ ((pi/2.0).^2.0-(kay*a.*sin(theta)/2.0).^2.0);
	E_phi_1 = E_phi_1.*cos(kay*a.*sin(theta)/2.0);
	E_phi_1 = A_phi*E_phi_1;

	E_phi_2 = A_phi*cos(kay*a*sin(theta)/2.0);
	E_phi = abs(E_phi_1 + E_phi_2*Co);
    %E-plane pattern : eq (8)
    %when clac E at forward hemispher set gamma to zero
	if ( (theta >= -pi/2) & (theta <= pi/2) ) 
        gamma=0; 
    end

	com = 1.0 + beta_k.*cos(theta) + gamma*(1.0 - beta_k.*cos(theta));
	com = com / (1.0 + beta_k + gamma*(1.0 - beta_k));
	if ( abs(theta) > 0.00001 ) 
        com = com .* sin(kay*b.*sin(theta)/2.0)./(kay*b.*sin(theta)/2.0);
    else
        com = com*1.0;
    end

	E_theta_1 = 1.0 + beta_k + gamma*(1.0 - beta_k);	%eq (9)
	E_theta_1 = E_theta_1*(2.0/pi)^2.0;
	E_theta_1 = E_theta_1*A_phi*com;

	E_theta_2 = A_phi*com;
	E_theta =abs( E_theta_1 + E_theta_2*Co );
    
    E_phi = E_phi .* cos(phi);
	E_theta = E_theta .* sin(phi);
end
