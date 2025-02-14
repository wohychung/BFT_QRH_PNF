classdef PlanarWaveSpectrum
	properties
		f       % Target frequency
		lambda  % Wavelength @ f
		k       % Wave number @ f
		E_H     % [ny, nx] Loaded E_H from PlanarNearField
		E_V     % [ny, nx] Loaded E_V from PlanarNearField
		coor    % [num_fft, num_fft] Coordinates generated for zero-padded fft
		kx_grid  % [num_fft, num_fft] Meshgrid for calculation
		ky_grid
    kz_grid
		kx
		ky
		nkx
		nky
		dkx
		dky
		f_x
		f_y
    gain_constant
	end
	methods
		function self = load_E(self, E_H, E_V, target_fidx)
			self.E_H = reshape(E_H(:,:,target_fidx), size(E_H, 1:2));
			self.E_V = reshape(E_V(:,:,target_fidx), size(E_V, 1:2));
		end

		function self = calculate_k(self, f)
			c = 299792458;
			lambda = c/f;
			er_air = 1.000649;
			k = 2*pi/lambda/sqrt(er_air);
      k = 2*pi/lambda;

			self.f = f;
			self.lambda = lambda;
			self.k = k;
		end

		function self = define_phase_coor(self, user_var, dkx, dky)
			E_H = self.E_H;
			E_V = self.E_V;
			k = self.k;

			nkx = user_var.num_fft;
			nky = user_var.num_fft;
			
			kx = linspace(-pi, pi, nkx+1);
			kx = kx(1:end-1)/dkx;
			
			ky = linspace(-pi, pi, nky+1);
			ky = ky(1:end-1)/dky;
			
			[ky_grid, kx_grid] = meshgrid(ky, kx);
			kz_grid = sqrt(k^2 - kx_grid.^2 - ky_grid.^2);
			coor(:,:,1) = kx_grid;
			coor(:,:,2) = ky_grid;
			coor(:,:,3) = kz_grid;

			self.kx = kx;
			self.ky = ky;
			self.kx_grid = kx_grid;
			self.ky_grid = ky_grid;
      self.kz_grid = kz_grid;
			self.nkx = nkx;
			self.nky = nky;
			self.coor = coor;
			self.dkx = dkx;
			self.dky = dky;
		end	

		function self = calculate_spectrum(self)
			nkx = self.nkx;
			nky = self.nky;
			E_H = self.E_H;
			E_V = self.E_V;
      kz_grid = self.kz_grid;
      lambda = self.lambda;

			f_x = fftshift(fft2(E_H, nkx, nky));
			f_y = fftshift(fft2(E_V, nkx, nky));

      % Calculate Evanescent mode
      f_x = f_x.*exp(1j*kz_grid*lambda);
      f_y = f_y.*exp(1j*kz_grid*lambda);

			self.f_x = f_x;
			self.f_y = f_y;
		end

		function plot(self)
			x = self.kx;
			y = self.ky;
      f_x = self.f_x;
      f_y = self.f_y;
			
			title1 = "f_x Magnitude";
      title2 = "f_x Phase";
			title3 = "f_y Magnitude";
      title4 = "f_y Phase";

			z1 = dB20(f_x);
      z2 = angle(f_x);
			z3 = dB20(f_y);
      z4 = angle(f_y);

			xlabel = "x (unitless)";
			ylabel = "y (unitless)";

			subplot(1,2,1); plot_imagesc(x, y, z1, title1, xlabel, ylabel);
			subplot(1,2,2); plot_imagesc(x, y, z2, title2, xlabel, ylabel);
      subplot(1,2,1); plot_imagesc(x, y, z3, title3, xlabel, ylabel);
			subplot(1,2,2); plot_imagesc(x, y, z4, title4, xlabel, ylabel);
		end

		function spherical_wave_spectrum = convert_to_spherical(self, user_var)
			dth = user_var.dth;
			dph = user_var.dph;

			% Initialize spherical_wave_spectrum
			spherical_wave_spectrum = SphericalWaveSpectrum();

			% Define polar grid
			spherical_wave_spectrum = spherical_wave_spectrum.define_polar_grid(dth, dph);
			
			% Load variables
			f_x = self.f_x;
			f_y = self.f_y;
			kx = self.kx;
			ky = self.ky;
			k = self.k;
			theta = spherical_wave_spectrum.theta;
			phi = spherical_wave_spectrum.phi;

			% Convert linear to spherical
			spherical_f_x = convert_linear_to_spherical_complex(f_x, kx, ky, k, theta, phi);
			spherical_f_y = convert_linear_to_spherical_complex(f_y, kx, ky, k, theta, phi);

			% Save variables
			spherical_wave_spectrum.k = k;
			spherical_wave_spectrum.f = self.f;
			spherical_wave_spectrum.lambda = self.lambda;
			spherical_wave_spectrum.f_x = spherical_f_x;
			spherical_wave_spectrum.f_y = spherical_f_y;
    end

    function self = calculate_gain_constant(self)
      dx = self.dkx;
      dy = self.dky;
      lambda = self.lambda;

      gain_constant = (4*pi*dx*dy/lambda^2)^2;

      self.gain_constant = gain_constant;
    end
	end
end
