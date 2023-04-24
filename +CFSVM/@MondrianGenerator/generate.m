function generate(obj, n_images, parameters)
% Generates and saves Mondrians.
%
% Args:
%   n_images: Int number of Mondrians to generate.
%
    arguments
        obj
        n_images
        parameters.fname = 'mondrian.png'
    end
    [~,name, ext] = fileparts(parameters.fname);
    w = waitbar(0, 'Starting');
    psds_matrix = [];
    for m = 1:n_images
        waitbar(m/n_images, w, sprintf('Generating Mondrians: %d %%', floor(m/n_images*100)));
        mondrian = obj.generate_mondrian();
        if obj.is_phys_props
            [freqs, psds] = obj.get_psd(mondrian);
            psds_matrix = [psds_matrix, psds];
        end
        imwrite(ind2rgb(mondrian, obj.cmap), fullfile(obj.dirpath, sprintf('Masks/%s_%d%s', name, m, ext)))
    end
    if obj.is_phys_props
        T = array2table([freqs, psds_matrix]);
        T.Properties.VariableNames(1:n_images+1) = ["freqs", arrayfun(@(s)(sprintf('%s_%d%s', name, s, ext)), 1:n_images, UniformOutput=false)];
        writetable(T,fullfile(obj.dirpath, 'mondrians_psds.csv'))
        f = figure('visible','off');
        semilogy(freqs, mean(psds_matrix, 2))
        title('Average PSD of generated Mondrians')
        xlabel('Spatial frequency [CPD]')
        ylabel('PSD')
        exportgraphics(f,fullfile(obj.dirpath, 'average_mondrians_psd.png'))
    end
    close(w);
end