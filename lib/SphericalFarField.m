classdef SphericalFarField
	properties
		theta
		phi
		dth
		dph
		f
		lambda
		k
		E_theta
		E_phi
		TRP
		W
		W_E
		W_H
		U
		U_Co
		U_Cross
		D
		D_Co
		D_Cross
		D_max_theta
		D_max_phi
		D_max
		D_Co_max_theta
		D_Co_max_phi
		D_Co_max
		D_Cross_max_theta
		D_Cross_max_phi
		D_Cross_max
    gain
    Gmax
    Gmax_E
    Gmax_H
	end
	methods
		function plot_E(self)
			plot_spherical_E(self.E_theta, self.E_phi);
      theta = self.theta;
			phi = self.phi;
			E_theta = self.E_theta;
			E_phi = self.E_phi;

      r1 = dB20(E_theta);
      r2 = rad2deg(angle(E_theta));
      r3 = dB20(E_phi);
      r4 = rad2deg(angle(E_phi));

			subplot(2,2,1); plot_spherical(theta, phi, r1)
			title('|E_\theta| (dB)')
      clim([-100, max(max(r1))])

			subplot(2,2,2); plot_spherical(theta, phi, r2)
			title('|E_\theta| (deg.)')

      subplot(2,2,3); plot_spherical(theta, phi, r3)
			title('|E_\phi| (dB)')
      clim([-100, max(max(r3))])

			subplot(2,2,4); plot_spherical(theta, phi, r4)
			title('|E_\phi| (deg.)')
		end

		function self = calculate_U(self)
			E_theta = self.E_theta;
			E_phi = self.E_phi;
			phi = self.phi;

			U = (abs(E_theta).^2 + abs(E_phi).^2);
			U_Co = (abs(E_theta.*cos(phi)-E_phi.*sin(phi))).^2;
			U_Cross = (abs(E_theta.*sin(phi)+E_phi.*cos(phi))).^2;

			self.U = U;
			self.U_Co = U_Co;
			self.U_Cross = U_Cross;
		end

		function self = calculate_TRP(self)
			theta = self.theta;
			phi = self.phi;
			U = self.U;
			dth = self.dth;
			dph = self.dph;

			e_theta = [1 4 repmat([2 4], 1, floor(length(theta(1,:))/2) - 1) 1];
			e_phi = [1 4 repmat([2 4], 1, floor(length(phi(:,1))/2) - 1) 1];
			TRP = dph*dth*sum(sum(U.*(e_theta'*e_phi).*abs(sin(theta))))/9;

			self.TRP = TRP;
		end

		function self = calculate_W(self)
			E_theta = self.E_theta;
			E_phi = self.E_phi;

      W = E_theta.*conj(E_theta)+E_phi.*conj(E_phi);
%       W = abs(E_theta + E_phi).^2;
%       W = (E_theta + E_phi).^2;

			self.W = W;
    end

    function self = calculate_EH(self)
      W = self.W;

      W_E = W(floor(size(W, 2)/2)+1,:);
      W_H = W(1,:);

      self.W_E = W_E;
      self.W_H = W_H;
    end

		function self = probe_correction(self, probe)
			W = self.W;
			theta = self.theta;
			pattern = probe.pattern;

			self.W = W.*cos(theta).^2 ./ pattern;
		end

		function self = calculate_D(self)
			U = self.U;
			TRP = self.TRP;
			U_Co = self.U_Co;
			U_Cross = self.U_Cross;
			theta = self.theta;
			phi = self.phi;

			D = 4*pi*U/TRP;
			D_Co = 4*pi*U_Co/TRP;
			D_Cross = 4*pi*U_Cross/TRP;

			[D_max_theta, D_max_phi, D_max] = get_spherical_maximum(theta, phi, D);
			[D_Co_max_theta, D_Co_max_phi, D_Co_max] = get_spherical_maximum(theta, phi, D_Co);
			[D_Cross_max_theta, D_Cross_max_phi, D_Cross_max] = get_spherical_maximum(theta, phi, D_Cross);

			self.D = D;
			self.D_Co = D_Co;
			self.D_Cross = D_Cross;

			self.D_max_theta = D_max_theta;
			self.D_max_phi = D_max_phi;
			self.D_max = D_max;
			self.D_Co_max_theta = D_Co_max_theta;
			self.D_Co_max_phi = D_Co_max_phi;
			self.D_Co_max = D_Co_max;
			self.D_Cross_max_theta = D_Co_max_theta;
			self.D_Cross_max_phi = D_Co_max_phi;
			self.D_Cross_max = D_Cross_max;
		end

		function plot_D(self)
			theta = self.theta;
			phi = self.phi;
			D = self.D;
			D_Co = self.D_Co;
			D_Cross = self.D_Cross;

			subplot(1,3,1); plot_spherical(theta, phi, D)
			title('Ludwig-3 Dir. (dB)')

			subplot(1,3,2); plot_spherical(theta, phi, D_Co)
			title('Ludwig-3 Co-Pol. Dir. (dB)')
			
			subplot(1,3,3); plot_spherical(theta, phi, D_Cross)
			title('Ludwig-3 Cross-Pol. Dir. (dB)')
		end

		function plot_U(self)
			theta = self.theta;
			phi = self.phi;
			U_Co = self.U_Co;
			U_Cross = self.U_Cross;

			subplot(1,2,1); plot_spherical(theta, phi, dB(U_Co))
			title('Co-Pol. Radiation Intensity (dB)')
      clim([-50 0])
			
			subplot(1,2,2); plot_spherical(theta, phi, dB(U_Cross))
			title('Cross-Pol. Radiation Intensity (dB)')
      clim([-50 0])
		end

		function plot_W(self)
			W = self.W;
      W = abs(W);
			theta = self.theta;
			phi = self.phi;

      r = W/max(W, [], "all");
      r = dB(r);

			plot_spherical(theta, phi, r)
			title('Radiated Power (dB)')
      clim([-50 0])
    end
    
    function plot_EH(self)
      W_E = self.W_E;
			W_H = self.W_H;
      E_theta = self.E_theta;
			theta = self.theta;
			phi = self.phi;

      z1 = dB(W_E) - max(dB(W_E));
      z2 = angle(E_theta(floor(size(E_theta, 2)/2)+1,:));
      z3 = dB(W_H) - max(dB(W_H));
      z4 = angle(E_theta(floor(size(E_theta, 2)/2)+1,:));

			subplot(2,2,1); hold on; plot(180/pi*theta(1,:), z1);
			title('E-Plane Magnitude');
			xlabel('\theta (degree)')
			ylabel('Directivity (dBi)');
			set(gca,'XLim',[-60 60]);
			set(gca,'YLim',[-60 0]);
      hold off;

			subplot(2,2,2); hold on; plot(180/pi*theta(1,:), z2);
			title('E-Plane Phase');
			xlabel('\theta (degree)')
			ylabel('Phase (deg.)');
% 			set(gca,'XLim',[-60 60]);
% 			set(gca,'YLim',[-60 0]);
      hold off;       

			subplot(2,2,3); hold on; plot(180/pi*phi(:,1) - 90, z3);
			title('H-Plane');
			xlabel('\theta (degree)');
			ylabel('Directivity (dBi)');
			set(gca,'XLim',[-60 60]);
			set(gca,'YLim',[-60 0]);
      hold off;

      subplot(2,2,4); hold on; plot(180/pi*phi(:,1) - 90, z4);
			title('H-Plane Phase');
			xlabel('\theta (degree)')
			ylabel('Phase (deg.)');
% 			set(gca,'XLim',[-60 60]);
% 			set(gca,'YLim',[-60 0]);
      hold off; 
		end

		function report_max_D(self)
			D_max = self.D_max;
			D_max_theta = self.D_max_theta;
			D_max_phi = self.D_max_phi;

			sprintf("Maximum D is %2.2f dB \n@ theta = %.2f deg. and phi = %.2f deg.", ...
				round(D_max, 2), ...
				round(rad2deg(D_max_theta), 2), ...
				round(rad2deg(D_max_phi), 2) ...
			)
		end

		function report_boresight_D(self)
			D = self.D;
			sprintf("Boresight D_Co is %.2f dB", mean(abs(D(:,1))))
    end

    function self = calculate_gain(self, planar_wave_spectrum, reflectometer, probe)
      planar_wave_spectrum = planar_wave_spectrum.calculate_gain_constant();
      gain_const = planar_wave_spectrum.gain_constant;
      W = self.W;
      mismatch = reflectometer.mismatch;
      thru = reflectometer.thru;
      pr_gain = probe.gain;

      gain = W * gain_const * mismatch / abs(thru)^2 / pr_gain;

      self.gain = gain;
    end

    function self = report_gain(self)
      gain = self.gain;
      gain = abs(gain);
      f = self.f;
      W = self.W;
      E_theta = self.E_theta;
			theta = self.theta;
			phi = self.phi;

      [Gmax, Gmax_idx] = max(gain, [], 'all');
      Gmax_E = max(gain(floor(size(W, 2)/2)+1,:));
      Gmax_H = max(gain(1,:));

      [theta_idx, phi_idx] = ind2sub(size(gain), Gmax_idx);
      
      disp(sprintf('Peak gain @ %.2f GHz = %.4f dB @ phi = %.1f deg / theta = %.1f deg', ...
        f/1e9, dB(Gmax), ...
        rad2deg(theta(1,theta_idx)), rad2deg(phi(phi_idx,1))))
      disp(sprintf('Peak E-plane gain @ %.2f GHz = %.4f dB', f/1e9, dB(Gmax_E)))
      disp(sprintf('Peak H-plane gain @ %.2f GHz = %.4f dB', f/1e9, dB(Gmax_H)))

      self.Gmax = Gmax;
      self.Gmax_E = Gmax_E;
      self.Gmax_H = Gmax_H;

      z1 = dB(gain(floor(size(W, 2)/2)+1,:));
      z2 = angle(E_theta(floor(size(E_theta, 2)/2)+1,:));
      z3 = dB(gain(1,:));
      z4 = angle(E_theta(floor(size(E_theta, 2)/2)+1,:));

			subplot(2,2,1); hold on; plot(180/pi*theta(1,:), z1);
			title('E-Plane Magnitude');
			xlabel('\theta (degree)')
			ylabel('Gain (dBi)');
			set(gca,'XLim',[-60 60]);
			set(gca,'YLim',[max(z1)-50 max(z1)]);
      hold off;

			subplot(2,2,2); hold on; plot(180/pi*theta(1,:), z2);
			title('E-Plane Phase');
			xlabel('\theta (degree)')
			ylabel('Phase (deg.)');
% 			set(gca,'XLim',[-60 60]);
% 			set(gca,'YLim',[-60 0]);
      hold off;       

			subplot(2,2,3); hold on; plot(180/pi*phi(:,1) - 90, z3);
			title('H-Plane Magnitude');
			xlabel('\theta (degree)');
			ylabel('Gain (dBi)');
			set(gca,'XLim',[-60 60]);
			set(gca,'YLim',[max(z3)-50 max(z3)]);
      hold off;

      subplot(2,2,4); hold on; plot(180/pi*phi(:,1) - 90, z4);
			title('H-Plane Phase');
			xlabel('\theta (degree)')
			ylabel('Phase (deg.)');
% 			set(gca,'XLim',[-60 60]);
% 			set(gca,'YLim',[-60 0]);
      hold off; 
    end

    function self = plot_gain(self)
      theta = self.theta;
      phi = self.phi;
      gain = self.gain;

      subplot(1,2,1)
      plot_spherical_v2(theta, phi, dB(gain))
			title('Gain (dB)')

      Gmax = max(dB(gain), [], 'all');
      clim([Gmax-50, Gmax])

      subplot(1,2,2)
      plot_spherical(theta, phi, dB(gain))
			title('Gain (dB)')

      Gmax = max(dB(gain), [], 'all');
      clim([Gmax-50, Gmax])
    end
	end
end
