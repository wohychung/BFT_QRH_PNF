classdef FarField
	properties
		theta
		phi
	end
	methods
		function self = define_polar_grid(self, dth, dph)
			[theta, phi] = define_polar_grid(dth, dph);

			self.theta = theta;
			self.phi = phi;
		end

		function self = calculate_farfield(self, 
	end
end
