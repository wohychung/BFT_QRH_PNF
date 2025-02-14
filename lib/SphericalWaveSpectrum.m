classdef SphericalWaveSpectrum
	properties
		theta
		phi
		dth
		dph
		f
		lambda
		k
		f_x
		f_y
	end
	methods
		function self = define_polar_grid(self, dth, dph)
			[theta, phi] = define_polar_grid(dth, dph);

			self.theta = theta;
			self.phi = phi;
			self.dth = dth;
			self.dph = dph;
		end

		function self = calculate_spherical_from_planar(self, planar_wave_spectrum)
			planar_f_x = planar_wave_spectrum.f_x;
			planar_f_y = planar_wave_spectrum.f_y;
			kx = planar_wave_spectrum.kx;
			ky = planar_wave_spectrum.ky;
			k = planar_wave_spectrum.k;
			theta = self.theta;
			phi = self.phi;

			f_x = convert_linear_to_spherical(planar_f_H, kx, ky, k, theta, phi);
			f_y = convert_linear_to_spherical(planar_f_V, kx, ky, k, theta, phi);

			self.k = k;
			self.f_x = f_x;
			self.f_y = f_y;
		end

		function spherical_FF = calculate_farfield(self)
			k = self.k;
			f_x = self.f_x;
			f_y = self.f_y;
			theta = self.theta;
			phi = self.phi;

			FF_E_theta=f_x.*cos(phi)+f_y.*sin(phi);
			FF_E_phi=cos(theta).*(-f_x.*sin(phi)+f_y.*cos(phi));

			spherical_FF = SphericalFarField();
			spherical_FF.f = self.f;
			spherical_FF.lambda = self.lambda;
			spherical_FF.k = k;
			spherical_FF.theta = theta;
			spherical_FF.phi = phi;
			spherical_FF.dth = self.dth;
			spherical_FF.dph = self.dph;
			spherical_FF.E_theta = FF_E_theta;
			spherical_FF.E_phi = FF_E_phi;
		end
	end
end
