function [temporal_frequency, temporal_psd] = get_temporal_amp(stimuli_array, sequence_duration)

    frames = size(stimuli_array, 4);

    gray_stimuli_array = CFSVM.Generators.CFSCrafter.convert_to_grayscale(stimuli_array);

    temporal_fft_array = fft(gray_stimuli_array, 2^nextpow2(frames), 4);
    temporal_psd = squeeze(mean(abs(temporal_fft_array), [1, 2]));
    temporal_psd = temporal_psd(1:end / 2 + 1);
    temporal_psd(2:end - 1) = 2 .* temporal_psd(2:end - 1);

    temporal_frequency = (0:2^nextpow2(frames) / 2)';
    temporal_frequency = temporal_frequency ./ sequence_duration;
end
