classdef Probe
	properties
		% Probe characteristics
		Ax
    Ay
		gain
    gamma
		f

		theta
		phi
		pattern

		% Physical constants
		c = 299792458;  % Speed of light in vacuum [m/s]
		mu0 = 4.0e-7*pi
		ep0 = 1.0 / (4.0e-7*pi*299792458^2)
		er_air = 1.000649

		% Variables for pattern calculation
    debug
		Pin = 10
		lambda
		k
		Eo
		A
		beta_k
    com
		E_phi
		E_phi_1
		E_phi_2
		E_theta
		E_theta_1
		E_theta_2
		Co
		W
	end

	methods
    function self = Probe(user_var)
      self.Ax = user_var.probe_Ax;
      self.Ay = user_var.probe_Ay;
      self.gain = user_var.probe_gain;
      self.gamma = user_var.probe_gamma;
    end

		function self = calculate_pattern(self, spherical_FF)
			% Load and save variables
      self.theta = spherical_FF.theta;
      self.phi = spherical_FF.phi;
      self.f = spherical_FF.f;
			self.lambda = self.c/self.f/sqrt(self.er_air);
			self.k = 2*pi/self.lambda;

			%Calculation of Magnitude of TE10 mode : Eo
			self = self.calculate_Eo();

			%Calculation of 1) eq. (7) : far-field H-plane pattern of OEG
			%2) eq. (8) : far-field E-plane pattern of OEG
			self = self.calculate_partial_E();
			self = self.calculate_Co();
			self = self.calculate_E();
      self = self.calculate_W();

      W = self.W;
      pattern = W/max(max(W));

			% Save variables
      self.pattern = pattern;
		end

    function self = calculate_W(self)
      E_theta = self.E_theta;
      E_phi = self.E_phi;
      gain = self.gain;

      W = E_theta.*conj(E_theta) + E_phi.*conj(E_phi);

      self.W = W;
    end

		function plot_pattern(self)
			pattern = self.pattern;
			theta = self.theta;
			phi = self.phi;

			plot_spherical(theta, phi, dB(pattern))
      clim([-20 0])
			title('Probe pattern (dB)')
		end
			
		%Calculation of Magnitude of TE10 mode : Eo
		function self = calculate_Eo(self)
			Ax = self.Ax;
			Ay = self.Ay;
			lambda = self.lambda;
			Pin = self.Pin;
			mu0 = self.mu0;
			ep0 = self.ep0;
			er_air = self.er_air;
			G = self.gamma;
			k = self.k;

			beta_k = sqrt(1-(lambda/(2*Ax))^2);
			Eo = Pin*4.0*sqrt(mu0/ep0/er_air);
			Eo = Eo / (Ax*Ay*(1.0-(abs(G)^2.0))*beta_k);
			Eo = sqrt(Eo);
			A = -1i*k^2*Ax*Ay*Eo / 8.0;

			self.beta_k = beta_k;
			self.Eo = Eo;
			self.A = A;
		end

		function self = calculate_partial_E(self)
			theta = self.theta;
			beta_k = self.beta_k;
			G = self.gamma;
			k = self.k;
			Ax = self.Ax;
			Ay = self.Ay;
			A = self.A;

			% Calculate partial E_phi
			E_phi_1 = cos(theta) + beta_k;
			E_phi_1 = E_phi_1 + G*(cos(theta) - beta_k);
			E_phi_1 = E_phi_1 ./ ((pi/2).^2-(k*Ax.*sin(theta)/2).^2);
			E_phi_1 = E_phi_1.*cos(k*Ax.*sin(theta)/2);
			E_phi_1 = A*E_phi_1;

			E_phi_2 = A*cos(k*Ax*sin(theta)/2);

      % G = 0 if -pi/2 < theta < pi/2
      G = G*(sign(abs(theta)-pi/2-1e-9)+1)/2;

			% Calculate Partial E_theta
			com = 1 + beta_k.*cos(theta) + G.*(1 - beta_k.*cos(theta));
			com = com ./ (1 + beta_k + G.*(1 - beta_k));

      % if abs(theta) > 0.00001, multiply com2
      com_flag = (sign(abs(theta)-0.00001)+1)/2;
      com2 = sin(k*Ay.*sin(theta)/2) ./ (k*Ay.*sin(theta)/2);
      com3 = com2.*com_flag + (1 - com_flag);
      com3(isnan(com3)) = 1; % Remove NaN occurred by 'divided by zero.'

      com = com .* com3;

			E_theta_1 = 1 + beta_k + G.*(1 - beta_k);	%eq (9)
			E_theta_1 = E_theta_1*(2/pi)^2;
			E_theta_1 = E_theta_1*A.*com;

			E_theta_2 = A*com;

			self.E_theta_1 = E_theta_1;
			self.E_theta_2 = E_theta_2;
			self.E_phi_1 = E_phi_1;
			self.E_phi_2 = E_phi_2;
      self.com = com;
		end

		function self = calculate_E(self)
			E_phi_1 = self.E_phi_1;
			E_phi_2 = self.E_phi_2;
			E_theta_1 = self.E_theta_1;
			E_theta_2 = self.E_theta_2;
			phi = self.phi;
			Co = self.Co;

			E_phi = abs(E_phi_1 + E_phi_2*Co);
			E_phi = E_phi .* cos(phi);

			E_theta =abs( E_theta_1 + E_theta_2*Co);
			E_theta = E_theta .* sin(phi);

			self.E_phi = E_phi;
			self.E_theta = E_theta;
    end

    function self = calculate_Co(self)
    	beta_k = self.beta_k;
      k = self.k;
    	beta = beta_k .* k;
			phi_lin = linspace(0, pi, 500);
			dphi = phi_lin(2) - phi_lin(1);
      Eo = self.Eo;
      G = self.gamma;
			Ax = self.Ax;
			Ay = self.Ay;

			probe_temp = self;
			probe_temp.theta = phi_lin;
			probe_temp = probe_temp.calculate_partial_E();

			E_phi_1_lin = probe_temp.E_phi_1;
			E_phi_2_lin = probe_temp.E_phi_2;
			E_theta_1_lin = probe_temp.E_theta_1;
			E_theta_2_lin = probe_temp.E_theta_2;

%       [E_phi_1_lin(end) E_phi_2_lin(end) E_theta_1_lin(end) E_theta_2_lin(end)]
          	
      DD = (abs(E_theta_2_lin.^2)+abs(E_phi_2_lin.^2)).*sin(phi_lin);
      EE = real(E_theta_1_lin.*conj(E_theta_2_lin) + E_phi_1_lin .*conj(E_phi_2_lin)).*sin(phi_lin);
      F1 = (abs(E_theta_1_lin.^2.0)+abs(E_phi_1_lin.^2.0)).*sin(phi_lin);

      DD = sum(DD)*dphi;
      EE = sum(EE)*dphi;
      F1 = sum(F1)*dphi;

    	F2 = - Ax*Ay*Eo.*Eo.*beta.*k/(2*pi).*(1 - (abs(G)).^2);
    	FF = F1 + F2;
    	if ((EE.*EE - DD.*FF) < 0)
    		disp('*** Error : EE*EE-DD*FF < 0 in Subroutune Co_factor');
      end

    	Co_plus  = ( -EE + sqrt(EE.*EE-DD.*FF) ) ./ DD;
    	Co_minus = ( -EE - sqrt(EE.*EE-DD.*FF) ) ./ DD;

    	Co = Co_plus;
    	%Check of Co
      Error_Co = DD.*Co.*Co + 2*EE.*Co + FF;
      Power_radiated = pi ./ (2*120*pi*k.*k);
     	Power_radiated = Power_radiated .* (DD.*Co.*Co + 2*EE.*Co + F1);

			self.Co = Co;
    end
  end
end
