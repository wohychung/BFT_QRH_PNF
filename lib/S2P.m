classdef S2P
    properties
        S   % Scattering parameter matrix [nf, 2, 2]
        SM	% Generalized scattering parameter when simultaneously conjugate matched [nf, 2, 2]
        SG  % Generalized scattering parameter matrix [nf, 2, 2]
        f   % Measured frequency [nf, 1]
        nf  % Number of measured frequency

        Z   % Impedance matrix [nf, 2, 2]
        Zi  % Input impedance of the DUT [nf, 1]
        Zo  % Output impedance of the DUT [nf, 1]
        Zs  % Source impedance of the port 1 [nf, 1]
        Zl  % Load impedance of the port 2 [nf, 1]
        Z0  % System impedance, normally 50 Ohm

        ZMs % Source impedance for simultaneous conjugate matching
        ZMl % Load impedance for simultaneous conjugate matching

        Gi  % Reflection coefficient of the input of the DUT [nf, 1]
        Go  % Reflection coefficient of the output of the DUT [nf, 1]
        Gs  % Reflection coefficient of the port 1 [nf, 1]
        Gl  % Reflection coefficient of the port 2 [nf, 1]

        Ps  % Phase factor of the source (generator), exp(1j*phi_s) [nf, 1]
        Pl  % Phase factor of the load, exp(1j*phi_l) [nf, 1]

        MAG % Complex maximum available gain when the source and load are perfectly matched [nf, 1]
    end
    methods
        %% Initialize
        function self = S2P(f, S11, S12, S21, S22, Zs, Zl, Z0)
            if nargin == 0
							return
						end
            self.f = f;
            self.nf = length(f);
            self.S = zeros([self.nf, 2, 2]);
            self.S(:,1,1) = S11;
            self.S(:,1,2) = S12;
            self.S(:,2,1) = S21;
            self.S(:,2,2) = S22;

            if length(Zs) == 1
                self.Zs = Zs * ones([self.nf, 1]);
            else
                self.Zs = Zs;
            end

            if length(Zl) == 1
                self.Zl = Zl * ones([self.nf, 1]);
            else
                self.Zl = Zl;
            end
            
            self.Z0 = Z0;
        end

        %% Calculate Z matrix
        function self = get_Z(self)
            for i = 1:self.nf
								Si = reshape(self.S(i,:,:), [2,2]);
                self.Z(i,:,:) = (eye(2) - Si)\(eye(2) + Si) * self.Z0;
                self.Zi(i,:) = self.Z(i,1,1) - (self.Z(i,1,2)*self.Z(i,2,1))/(self.Z(i,2,2) + self.Zl(i));
                self.Zo(i,:) = self.Z(i,2,2) - (self.Z(i,1,2)*self.Z(i,2,1))/(self.Z(i,1,1) + self.Zs(i));
            end
        end
        
        %% Calculate reflection coefficient
        function self = get_G(self)
            if isempty(self.Z)
                self = self.get_Z();
            end
            self.Gi = (self.Zi - self.Z0)./(self.Zi + self.Z0);
            self.Go = (self.Zo - self.Z0)./(self.Zo + self.Z0);
            self.Gs = (self.Zs - self.Z0)./(self.Zs + self.Z0);
            self.Gl = (self.Zl - self.Z0)./(self.Zl + self.Z0);
%             for i = 1:self.nf
%                 self.Gi(i) = (self.Zi(i) - self.Z0)/(self.Zi(i) + self.Z0);
%                 self.Go(i) = (self.Zo(i) - self.Z0)/(self.Zo(i) + self.Z0);
%                 self.Gs(i) = (self.Zs(i) - self.Z0)/(self.Zs(i) + self.Z0);
%                 self.Gl(i) = (self.Zl(i) - self.Z0)/(self.Zl(i) + self.Z0);
%             end
        end

        %% Calculate phase factor
        function self = get_P(self)
            if isempty(self.Gl)
                self = self.get_G();
            end
            self.Pl = abs(1 - self.Gl) ./ (1 - self.Gl);
            self.Ps = abs(1 - self.Gs) ./ (1 - self.Gs);
        end

        %% Calculate generalized s-parameters (SG)
        function self = get_SG(self)
            if isempty(self.Gs)
                self = self.get_G();
            end
						if isempty(self.Ps)
							  self = self.get_P();
						end
            for i = 1:self.nf
								Si = reshape(self.S(i,:,:), [2,2]);
                G = [self.Gs(i), 0; ...
                    0, self.Gl(i)];
                F = [self.Ps(i)/sqrt(1 - abs(self.Gs(i))^2), 0; ...
                    0, self.Pl(i)/sqrt(1 - abs(self.Gl(i))^2)];
                self.SG(i,:,:) = conj(F) ...
                    *(Si-conj(G)) ...
                    /(eye(2) - G*Si) ...
                    /F;
            end
        end

        %% Calculate simultaneous matching impedance(ZMs, ZMl)
        function self = get_ZM(self)
            det = self.S(:,1,1).*self.S(:,2,2) - self.S(:,1,2).*self.S(:,2,1);
            B1 = 1 + abs(self.S(:,1,1)).^2 - abs(self.S(:,2,2)).^2 - abs(det).^2;
            B2 = 1 + abs(self.S(:,2,2)).^2 - abs(self.S(:,1,1)).^2 - abs(det).^2;
            C1 = self.S(:,1,1) - det.*conj(self.S(:,2,2));
            C2 = self.S(:,2,2) - det.*conj(self.S(:,1,1));
            for i = 1:self.nf
                if (B1(i) > 0) && (B2(i) > 0)
                    GMs = (B1(i) - sqrt(B1(i)^2 - 4*abs(C1(i))^2)) ...
                        /(2*C1(i));
                    GMl = (B2(i) - sqrt(B2(i)^2 - 4*abs(C2(i))^2)) ...
                        /(2*C2(i));
                else
                    GMs = (B1(i) + sqrt(B1(i)^2 - 4*abs(C1(i))^2)) ...
                        /(2*C1(i));
                    GMl = (B2(i) + sqrt(B2(i)^2 - 4*abs(C2(i))^2)) ...
                        /(2*C2(i));
                end
                self.ZMs(i,:) = self.Z0 * (1 + GMs) / (1 - GMs);
                self.ZMl(i,:) = self.Z0 * (1 + GMl) / (1 - GMl);
            end
        end

        %% Calculate complex maximum abailable gain (MAG)
        function self = get_MAG(self)
            if isempty(self.ZMs)
                self = self.get_ZM();
            end
            matched = S2P(self.f, ...
                self.S(:,1,1), ...
                self.S(:,1,2), ...
                self.S(:,2,1), ...
                self.S(:,2,2), ...
                self.ZMs, ...
                self.ZMl, ...
                self.Z0);
            matched = matched.get_SG();
						self.SM = matched.SG;
            self.MAG = matched.SG(:,2,1);
        end
    end
end
