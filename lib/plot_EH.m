function plot_EH(theta, E, H)
		subplot(1,2,1);
%     plot( ...
%         180/pi*theta(1,:), E, ...
%         [-25 -25], [-30 0], 'k', ...
%         [25 25], [-30 0], 'k', ...
%         [-90 90], [-13.6 -13.6], 'k' ...
%     );
    plot(180/pi*theta(1,:), E);
    title('E-Plane');
%     xlabel('LOAD \leftarrow \theta (Deg) \rightarrow INPUT');
    xlabel('\theta (degree)')
    ylabel('Directivity (dBi)');
    set(gca,'XLim',[-90 90]);
    set(gca,'YLim',[-30 0]);
    subplot(1,2,2);
    plot(180/pi*theta(1,:), H);
    title('H-Plane');
    xlabel('\theta (degree)');
    ylabel('Directivity (dBi)');
    set(gca,'XLim',[-90 90]);
    set(gca,'YLim',[-30 0]);
end
