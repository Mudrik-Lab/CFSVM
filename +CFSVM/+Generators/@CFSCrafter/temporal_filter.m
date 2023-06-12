function temporal_filter(obj, filter_parameters)
    arguments
        obj
        filter_parameters.l_freq = []
        filter_parameters.h_freq = []
        filter_parameters.method = 'Gaussian'
        filter_parameters.order = []
    end
    sequence_duration = obj.total_frames / obj.refresh_rate;
    temporal_map = abs(-obj.total_frames / 2:obj.total_frames / 2 - 1);
    temporal_map = reshape(temporal_map, 1, 1, obj.total_frames);

    l_freq = filter_parameters.l_freq * sequence_duration;
    h_freq = filter_parameters.h_freq * sequence_duration;
    temporal_filter = obj.band_pass_filter( ...
                                           filter_parameters.method, ...
                                           temporal_map, ...
                                           l_freq = l_freq, ...
                                           h_freq = h_freq, ...
                                           order = filter_parameters.order);

    temporal_filter = reshape(temporal_filter, 1, 1, 1, []);
    obj.fft_stimuli = obj.fft_stimuli .* temporal_filter;
end
