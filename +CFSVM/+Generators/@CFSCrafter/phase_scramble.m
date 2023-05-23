function phase_scramble(obj, parameters)
    arguments
        obj
        parameters.l_freq = []
        parameters.h_freq = []
        parameters.scrambling_index = 1
    end
    l_freq = parameters.l_freq;
    h_freq = parameters.h_freq;
    if ~isempty(l_freq)
        PS_low = 0;
        PS_high = PS.cutoff_cpd * CFSVM.Utils.pix2deg(obj.padded_stimuli_dim(1),screen_width_cm,screen_width_pixel,viewing_distance);
        if ~isempty(h_freq)
            PS_low = PS.cutoff_cpd(1) * CFSVM.Utils.pix2deg(obj.padded_stimuli_dim(1),screen_width_cm,screen_width_pixel,viewing_distance);
            PS_high = PS.cutoff_cpd(2) * CFSVM.Utils.pix2deg(obj.padded_stimuli_dim(1),screen_width_cm,screen_width_pixel,viewing_distance);
        end
    elseif ~isempty(h_freq)
        PS_low = PS.cutoff_cpd * CFSVM.Utils.pix2deg(obj.padded_stimuli_dim(1),screen_width_cm,screen_width_pixel,viewing_distance);
        PS_high = ceil(max(max(obj.spatial_map)));
    else
        PS_low = 0;
        PS_high = ceil(max(max(obj.spatial_map)));
    end

    freq_range = obj.spatial_map >= PS_low & obj.spatial_map <= PS_high;

    freq_range = fftshift(freq_range);

    mask_stay_frame = obj.refresh_rate / obj.update_rate;

    n_unique_phase = obj.padded_stimuli_dim(4)/mask_stay_frame;

    random_phase = parameters.scrambling_index .* freq_range .* angle(fftn(rand(obj.padded_stimuli_dim(1), obj.padded_stimuli_dim(2), 1, n_unique_phase)));
    random_phase = repmat(random_phase,1,1,1,mask_stay_frame);

    magnitude = abs(obj.fft_stimuli);
    phase = angle(obj.fft_stimuli);
    phase = phase + random_phase;
    obj.fft_stimuli = magnitude.*exp(1i*(phase));
end