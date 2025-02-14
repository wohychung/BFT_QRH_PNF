    a=22.9e-3;
    b=10.1e-3;
    freq = 9.32e9;
    
    close all;
    c0=299792458;  % Speed of light in vacuum [m/s]
    mu0 = 4.0e-7 * pi;
	ep0 = 1.0 / (mu0*c0*c0);
    er_air = 1.000649;
    
    gamma = 7.514953613281250E-002 + 0.290298461914062i;
    lambda = c0/freq/sqrt(er_air);
    kay = 2*pi/lambda;
    
    Power_input = 10; %[W]
	%Calculation of Magnitude of TE10 mode : Eo
    beta_k = sqrt(1-(lambda/(2*a))^2);
    Eo = Power_input*4.0*sqrt(mu0/ep0/er_air);
    Eo = Eo / (a*b*(1.0-(abs(gamma)^2.0))*beta_k);
    Eo = sqrt(Eo);
    
    beta_k = sqrt(1.0 - (lambda/(2.0*a))^2);

	A_phi = -i*kay^2*a*b*Eo/8.0;

	gamma=0;
   
    theta = -pi/2:0.01:pi/2;
	com = 1.0 + beta_k*cos(theta) + gamma*(1.0 - beta_k*cos(theta));
	com = com / (1.0 + beta_k + gamma*(1.0 - beta_k));
	if ( abs(theta) > 0.0001)
	   com = com .* sin(kay*b.*sin(theta)/2.0)./(kay*b.*sin(theta)/2.0);
    end;

	E_theta_1 = 1.0 + beta_k + gamma*(1.0 - beta_k);	%eq (9)
	E_theta_1 = E_theta_1*(2.0/pi)^2.0;
	E_theta_1 = E_theta_1*A_phi*com;

	E_theta_2 = A_phi*com;
    
    plot(theta*180/pi,20*log10(abs(E_theta_2)/max(abs(E_theta_2))));
    grid on;
