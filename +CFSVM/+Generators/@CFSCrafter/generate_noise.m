function generate_noise( ...
    obj, ...
    mask_resolution, ...
    sequence_duration_sec, ...
    is_pink)

    n_distinct_masks = sequence_duration_sec * obj.update_rate;

    for i = 1:n_distinct_masks
        individual_masks(:,:,:,i) = obj.create_single_noise_mask(mask_resolution(1), mask_resolution(2), is_pink);
    end
    individual_masks = obj.set_rms_and_luminance(individual_masks);
    obj.stimuli_array = repelem(individual_masks, 1, 1, 1, obj.stay_frame);
    obj.fft_stimuli = fftn(obj.stimuli_array, obj.padded_stimuli_dim);
end

