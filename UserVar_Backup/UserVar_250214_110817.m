classdef UserVar
	properties
		% Input rawdata type and path
    target_path_Hpol = ""
    target_path_Vpol = "./rawdata/BFT_QRH_P1_5GHz_241106.pnf"

    % Probe characteristics
		probe_Ax = 47.55e-3   %[m]
    probe_Ay = 22.15e-3   %[m]
    probe_gain = 10^(6/10)
    probe_gamma = -0.05685696 -0.093753241i

    % Reflectometer characteristics
    reflectometer_gamma_load = 1e-2
		reflectometer_gamma_source = 1e-2
		reflectometer_thru = 2.0744436+1.8818767i

    % AUT (antenna under test) characteristics
    aut_gamma = -0.0058247894-0.005099697i
		aut_coor = [0, 0.79, 1]

    % Variables for calculation
		target_fidx = 1 % frequency index for test
		dth = deg2rad(1); % theta resolution
		dph = deg2rad(1); % phi resolution
    num_fft = 512;

    % Etc.
    fi
	end
	methods
	end
end
