function generate(obj, n_images)
    w = waitbar(0, 'Starting');
    psds_matrix = [];
    for m = 1:n_images
        waitbar(m/n_images, w, sprintf('Generating Mondrians: %d %%', floor(m/n_images*100)));
        mondrian = obj.generate_mondrian();
        if obj.is_phys_props
            [freqs, psds] = obj.get_psd(mondrian);
        end
        psds_matrix = [psds_matrix, psds];
        imwrite(ind2rgb(mondrian, obj.cmap), fullfile(obj.dirpath, sprintf('Masks/mondrian_%d.png', m)))
    end
    T = array2table([freqs, psds_matrix]);
    T.Properties.VariableNames(1:n_images+1) = ["freqs", arrayfun(@(s)(sprintf("mondrian_%d.png", s)), 1:n_images)];
    writetable(T,fullfile(obj.dirpath, 'mondrians_psds.csv'))
    f = figure('visible','off');
    semilogy(freqs, mean(psds_matrix, 2))
    title('Average PSD of generated Mondrians')
    xlabel('Cycles Per Degree')
    ylabel('Power Spectral Density')
    exportgraphics(f,fullfile(obj.dirpath, 'average_mondrians_psd.png'))
    close(w);
end