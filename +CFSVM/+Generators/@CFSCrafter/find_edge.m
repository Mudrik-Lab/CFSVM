function [edge_array, edge_density, thresh_out] = find_edge(stimuli_array, detection_method, detection_threshold)

    gray_stimuli_array = CFSVM.Generators.CFSCrafter.convert_to_grayscale(stimuli_array);

    for i = 1:size(stimuli_array, 4)
        [edge_array(:, :, i), thresh_out] = edge( ...
                                                 gray_stimuli_array(:, :, :, i), ...
                                                 detection_method, ...
                                                 detection_threshold);
    end

    edge_density = mean(edge_array, 'all');
end
