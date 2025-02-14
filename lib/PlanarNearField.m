classdef PlanarNearField
  properties
    x     % [1, nx] x-axis of measured near-field data
    dx    % Step of x-axis
    nx    % Number of data in x-axis
    y     % [1, ny] y-axis of measured near-field data
    dy    % Step of y-axis
    ny    % Number of data in y-axis
    coor  % [ny, nx, 2] Measured coordinates of the near-field data
    s2p_H % [ny, nx] s2p data of H-pol measurement
    s2p_V % [ny, nx] s2p data of V-pol measurement
		f     % [1, nf] Measured frequencies
		fi    % Target frequency
		E_H   % [ny, nx] E-field data of H-pol
		E_V   % [ny, nx] E-field data of V-pol
  end
  methods
    % Extract measured s21 data and corresponding coordinates from .pnf file
		function self = load_pnf(self, user_var)
      rawdata_H_path = user_var.target_path_Hpol;
      rawdata_V_path = user_var.target_path_Vpol;

      if ~exist(rawdata_H_path, 'file')
        [E_V, f, x, y, dx, dy, nx, ny, coor] = load_pnf(rawdata_V_path);
        E_H = zeros(size(E_V));
      elseif ~exist(rawdata_V_path, 'file')
        [E_H, f, x, y, dx, dy, nx, ny, coor] = load_pnf(rawdata_H_path);
        E_V = zeros(size(E_H));
      else
        [E_V, f, x, y, dx, dy, nx, ny, coor] = load_pnf(rawdata_V_path);
        [E_H, ~, ~, ~, ~, ~, ~, ~, ~] = load_pnf(rawdata_H_path);
      end
			
      fi = f(user_var.target_fidx);

			self.E_V = E_V;
      self.E_H = E_H;
			self.f = f;
      self.fi = fi;
			self.x = x;
			self.y = y;
			self.dx = dx;
			self.dy = dy;
			self.nx = nx;
			self.ny = ny;
      self.coor = coor;
		end

    % Load .s2p files located in s2p_H_path and s2p_V_path
    % Also extracts coordinates from filenames
		function self = load_s2p(self, user_var)	
			[self.coor, self.f, self.s2p_H, self.x, self.y, self.nx, self.ny, self.dx, self.dy] = load_dataset(rawdata_H_path);

			if exist(rawdata_V_path, 'dir')
				[~, ~, self.s2p_V, ~, ~, ~, ~, ~, ~] = load_dataset(rawdata_V_path);
			else
				%% Create dummy dataset
				% This is unnecessary if we have legit Vpol measurement data
				self.s2p_V = create_dummy_s2p(self.nx, self.ny, self.f);
      end
		end

    % Scale coordinates according to scale variable
		function self = adjust_coor(self, scale)
			self.coor = self.coor*scale;
			self.dx = self.dx*scale;
			self.dy = self.dy*scale;
			self.x = self.x*scale;
			self.y = self.y*scale;
		end

    % Shift coordinates so that the center of the measured coordinates
    % could be [0, 0]
		function self = recenter_coor(self)
			mx = mean(self.x);
			my = mean(self.y);
			self.x = self.x - mx;
			self.y = self.y - my;
			self.coor(:,:,1) = self.coor(:,:,1) - mx;
			self.coor(:,:,2) = self.coor(:,:,2) - my;
		end

    % Plot the magnitude of the measured s21 @ target frequency index
		function plot_s21_mag(self, user_var)
			f = self.f;
			target_fidx = user_var.target_fidx;
			x = self.x;
			y = self.y;

			for ix = 1:length(x)
				for iy = 1:length(y)
					z1(iy, ix) = self.s2p_H(iy, ix).S(target_fidx, 2, 1);
					z2(iy, ix) = self.s2p_V(iy, ix).S(target_fidx, 2, 1);
				end
			end
			z1 = dB20(z1);
			z2 = dB20(z2);

			title = sprintf("|S21| @ %.1f GHz (dB)", f(target_fidx)/1e9);
			xlabel = "x (m)";
			ylabel = "y (m)";

			subplot(1,2,1); plot_imagesc(x, y, z1, title, xlabel, ylabel);
			subplot(1,2,2); plot_imagesc(x, y, z2, title, xlabel, ylabel);
		end

    % From s2p data, calculate gain under perfectly matched condition,
    % then assign them to E
		function self = get_matched_E_VNA(self, user_var)
			s2p_H = self.s2p_H;
			s2p_V = self.s2p_V;
			nx = size(self.s2p_H, 2);
			ny = size(self.s2p_H, 1);
			E_H = nan([ny, nx]);
			E_V = nan([ny, nx]);
			fidx = user_var.target_fidx;

			for ix = 1:nx
				for iy = 1:ny
					s2p_H(iy, ix) = s2p_H(iy, ix).get_MAG();
					s2p_V(iy, ix) = s2p_V(iy, ix).get_MAG();

					E_H(iy, ix) = s2p_H(iy, ix).MAG(fidx);
					E_V(iy, ix) = s2p_V(iy, ix).MAG(fidx);
				end
			end

			self.s2p_H = s2p_H;
			self.s2p_V = s2p_V;
			self.E_H = E_H;
			self.E_V = E_V;
			self.fi = self.f(fidx);
		end

		function self = calibrate_reflectometer(self, reflectometer)
%       mismatch = reflectometer.mismatch;
%       thru = reflectometer.thru;
      H = self.H;
% 			nx = size(self.H, 2);
% 			ny = size(self.H, 1);
% 
% 			E_H = H * mismatch / abs(thru)^2;
% 			E_V = 1e-100 * ones([ny, nx]);

      E_H = H;
      E_V = zeros(size(H));
      self.fi = self.f;

			self.E_H = E_H;
			self.E_V = E_V;
		end

    % Plot E_H and E_V @ target frequency
		function plot_E(self)
			fi = self.fi;
			x = self.x;
			y = self.y;
			E_H = self.E_H;
			E_V = self.E_V;

			z11 = dB20(E_H);
      z12 = angle(E_H);
			z21 = dB20(E_V);
      z22 = angle(E_V);

			title11 = sprintf("|E_H| @ %.1f GHz (dB)", fi/1e9);
      title12 = sprintf("Phase(E_H) @ %.1f GHz (dB)", fi/1e9);
			title21 = sprintf("|E_V| @ %.1f GHz (dB)", fi/1e9);
      title22 = sprintf("Phase(E_V) @ %.1f GHz (dB)", fi/1e9);
			xlabel = "x (m)";
			ylabel = "y (m)";

			subplot(2,2,1); plot_imagesc(x, y, z11, title11, xlabel, ylabel);
      subplot(2,2,2); plot_imagesc(x, y, z12, title12, xlabel, ylabel);
      subplot(2,2,3); plot_imagesc(x, y, z21, title21, xlabel, ylabel);
      subplot(2,2,4); plot_imagesc(x, y, z22, title22, xlabel, ylabel);
		end

    % Calculate and define planar wave spectrum
		function planar_wave_spectrum = calculate_planar_wave_spectrum(self, user_var)
			target_fidx = user_var.target_fidx;
			E_H = self.E_H;
			E_V = self.E_V;
			dx = self.dx;
			dy = self.dy;
			f = self.f(target_fidx);
			planar_wave_spectrum = PlanarWaveSpectrum();
			planar_wave_spectrum.E_H = E_H;
			planar_wave_spectrum.E_V = E_V;
			planar_wave_spectrum.f = f;
			planar_wave_spectrum = planar_wave_spectrum.calculate_k(f);
			planar_wave_spectrum = planar_wave_spectrum.define_phase_coor(user_var, dx, dy);
			planar_wave_spectrum = planar_wave_spectrum.calculate_spectrum();
    end
  end
end
