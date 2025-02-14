classdef Reflectometer
	properties
		gamma_load
		gamma_source
		thru
		gamma_aut
    gamma_probe

		mismatch
	end
	methods
    function self = Reflectometer(user_var)
      self.gamma_load = user_var.reflectometer_gamma_load;
  		self.gamma_source = user_var.reflectometer_gamma_source;
  		self.thru = user_var.reflectometer_thru;
  		self.gamma_aut = user_var.aut_gamma;
      self.gamma_probe = user_var.probe_gamma;

      self = calculate_mismatch(self);
    end

		function self = calculate_mismatch(self)
			% Load var
			Gl = self.gamma_load;
			Gs = self.gamma_source;
			Gi = self.gamma_aut;
			Go = self.gamma_probe;

			% Calculate mismatch
			mismatch = abs(1 - Gl*Go)^2 ...
				* abs(1 - Gs*Gi)^2;
			mismatch = mismatch ...
				/( ...
					abs(1-Gs*Gl)^2 ...
					*(1 - abs(Gi)^2) ...
					*(1-abs(Go)^2) ...
				);

			% Save var
			self.mismatch = mismatch;
		end
	end
end
