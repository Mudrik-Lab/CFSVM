function get_max(obj, trial_matrix)
% Gets overall maximum number of masks from all blocks and trials.
%
% Args:
%   trial_matrix: Cell array with blocks and trials from the trials object.
%
    
    temp_freqs = cellfun(@(block) (cellfun(@(trial) (trial.masks.temporal_frequency), block)), trial_matrix, UniformOutput=false);
    mask_durations = cellfun(@(block) (cellfun(@(trial) (trial.masks.duration), block)), trial_matrix, UniformOutput=false);
    max_temporal_frequency = max([temp_freqs{:}]);
    max_mask_duration = max([mask_durations{:}]);

    obj.n_max = max_temporal_frequency*max_mask_duration;

end