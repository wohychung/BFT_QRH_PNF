classdef UserVar
	properties
		% Input rawdata type and path
    %target_path_Hpol = "\\10.161.11.118\bft\06_NFFF\8_QRH\dataset\BFT_QRH_241108\BFT_DR_P1_4GHz_241106.pnf"
    target_path_Hpol = ""
    target_path_Vpol = "\\10.161.11.118\bft\06_NFFF\8_QRH\dataset\BFT_QRH_241108\BFT_DR_P2_4GHz_241106.pnf"
%     target_path_Vpol = ""

    % Probe characteristics
		probe_Ax = 47.55e-3   %[m]
    probe_Ay = 22.15e-3   %[m]
    probe_gain = 10^(6/10)
    probe_gamma = 0.060950749 -0.11372826i

    % Reflectometer characteristics
    reflectometer_gamma_load = 1e-2
		reflectometer_gamma_source = 1e-2
		reflectometer_thru = -1.3768507-1.8947903i

    % AUT (antenna under test) characteristics
    aut_gamma = -0.0051186173-0.015864125i
		aut_coor = [0, 0.79, 1]

    % Variables for calculation
		target_fidx = 1 % frequency index for test
		dth = 0.005; % theta resolution
		dph = 0.005; % phi resolution
    num_fft = 1024;

    % Etc.
    fi
	end
	methods
	end
end
