function initiate(obj, trial_matrices)
% INITIATE Gets maximum number of masks from all blocks and trials.

    max_temporal_frequency = max(cellfun(@(matrix) (max(matrix.('masks.temporal_frequency'))), trial_matrices));
    max_mask_duration = max(cellfun(@(matrix) (max(matrix.('masks.duration'))), trial_matrices));
    
    % +1 is because is there will be x+1 masks flashed.
    obj.n_max = max_temporal_frequency*max_mask_duration+1;

end
