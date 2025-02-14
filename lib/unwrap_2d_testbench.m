phase = angle(planar_NF.E_V);
phase_unwrap = unwrap_2d(phase);

figure(1)
subplot(1,2,1)
imagesc(phase)

subplot(1,2,2)
imagesc(phase_unwrap)
colorbar;

figure(2)
plot(diff(phase_unwrap, 1))