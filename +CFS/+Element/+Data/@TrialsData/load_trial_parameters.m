function load_trial_parameters(obj, experiment)
% LOAD_TRIAL_PARAMETERS Loads row from the current trial matrix.
    
    STATICS = {'screen', 'subject_info', 'trials'};
    
    for property = setdiff(properties(experiment)', STATICS)
        experiment.(property{:}) = obj.matrix{obj.block_index}{obj.trial_index}.(property{:});
    end

end

