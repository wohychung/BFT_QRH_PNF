function plot_imagesc(x, y, z, ...
	plot_title, plot_xlabel, plot_ylabel ...
)
	imagesc(x, y, z)
	ylabel(plot_ylabel)
	xlabel(plot_xlabel)
	title(plot_title)
	colorbar;
	colormap turbo
end
