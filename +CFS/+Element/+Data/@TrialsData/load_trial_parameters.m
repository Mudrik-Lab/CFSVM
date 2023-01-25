function load_trial_parameters(obj, experiment)
% LOAD_TRIAL_PARAMETERS For the current trial update its parameters.
    
    dont_load = {'screen', 'subject_info', 'trials'};
    
    for property = setdiff(properties(experiment)', dont_load)
        experiment.(property{:}) = obj.matrix{obj.block_index}{obj.trial_index}.(property{:});
    end

end

