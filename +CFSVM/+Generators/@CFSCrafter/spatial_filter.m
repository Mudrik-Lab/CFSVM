function spatial_filter(obj, filter_parameters)
    arguments
        obj
        filter_parameters.l_freq = []
        filter_parameters.h_freq = []
        filter_parameters.method = 'Gaussian'
        filter_parameters.order = []
    end
    if isempty(filter_parameters.l_freq) && isempty(filter_parameters.h_freq)
        error('Provide at least one cuttoff frequency');
    end

    deg = CFSVM.Utils.pix2deg( ...
                              obj.padded_stimuli_dim(1), ...
                              obj.screen_info.width_cm, ...
                              obj.screen_info.width_pixel, ...
                              obj.screen_info.viewing_distance);
    l_freq = filter_parameters.l_freq * deg;
    h_freq = filter_parameters.h_freq * deg;

    spatial_filter = obj.band_pass_filter( ...
                                          filter_parameters.method, ...
                                          obj.spatial_map, ...
                                          l_freq = l_freq, ...
                                          h_freq = h_freq, ...
                                          order = filter_parameters.order);

    obj.fft_stimuli = obj.fft_stimuli .* spatial_filter;

end
