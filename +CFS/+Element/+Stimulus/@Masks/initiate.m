function initiate(obj, trial_matrix)
% INITIATE Gets maximum number of masks from all blocks and trials.
    
    temp_freqs = cellfun(@(block) (cellfun(@(trial) (trial.masks.temporal_frequency), block)), trial_matrix, UniformOutput=false);
    mask_durations = cellfun(@(block) (cellfun(@(trial) (trial.masks.duration), block)), trial_matrix, UniformOutput=false);
    max_temporal_frequency = max([temp_freqs{:}]);
    max_mask_duration = max([mask_durations{:}]);
    
    % +1 is because is there will be x+1 masks flashed.
    obj.n_max = max_temporal_frequency*max_mask_duration+1;

end
