function phase_scramble(obj, parameters)
    arguments
        obj
        parameters.phase_scramble_index = 1
        parameters.l_freq = []
        parameters.h_freq = []

    end
    l_freq = parameters.l_freq;
    h_freq = parameters.h_freq;
    if isempty(l_freq) && isempty(h_freq)
        % all frequencies
        PS_low = 0;
        PS_high = ceil(max(max(obj.spatial_map)));
    else
        pix = CFSVM.Utils.pix2deg( ...
                                  obj.padded_stimuli_dim(1), ...
                                  obj.screen_info.width_cm, ...
                                  obj.screen_info.width_pixel, ...
                                  obj.screen_info.viewing_distance);
        if ~isempty(h_freq)
            if ~isempty(l_freq)
                % band-pass
                PS_low = l_freq * pix;
                PS_high = h_freq * pix;
            else
                % low-pass
                PS_low = 0;
                PS_high = h_freq * pix;
            end
        else
            % high-pass
            PS_low = l_freq * pix;
            PS_high = ceil(max(max(obj.spatial_map)));
        end
    end

    freq_range = obj.spatial_map >= PS_low & obj.spatial_map <= PS_high;

    freq_range = fftshift(freq_range);

    mask_stay_frame = obj.refresh_rate / obj.update_rate;

    n_unique_phase = obj.padded_stimuli_dim(4) / mask_stay_frame;

    random_phase = parameters.phase_scramble_index .* freq_range .* angle(fftn(rand(obj.padded_stimuli_dim(1), obj.padded_stimuli_dim(2), 1, n_unique_phase)));
    random_phase = repmat(random_phase, 1, 1, 1, mask_stay_frame);

    magnitude = abs(obj.fft_stimuli);
    phase = angle(obj.fft_stimuli);
    phase = phase + random_phase;
    obj.fft_stimuli = magnitude .* exp(1i * (phase));
end
