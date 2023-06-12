function gray_stimuli_array = convert_to_grayscale(stimuli_array)
    [~, ~, color, ~] = size(stimuli_array);
    if color == 1
        gray_stimuli_array = stimuli_array;
    else
        gray_stimuli_array = 0.2989 * stimuli_array(:, :, 1, :) + 0.5870 * stimuli_array(:, :, 2, :) + 0.1140 * stimuli_array(:, :, 3, :);
    end
end
