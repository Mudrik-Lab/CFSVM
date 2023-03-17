function load_trial_parameters(obj, experiment)
% Updates parameters for current trial.
%
% Args:
%   experiment: An experiment object to update properties in.
    
    dont_load = {'screen', 'subject_info', 'trials'};
    
    for property = setdiff(properties(experiment)', dont_load)
        experiment.(property{:}) = obj.matrix{obj.block_index}{obj.trial_index}.(property{:});
    end

end

