function load_trial_parameters(obj, experiment)
% LOAD_TRIAL_PARAMETERS Loads row from the current trial matrix.

    block = obj.blocks{obj.block_index};
    for property = block(obj.trial_index,:).Properties.VariableNames
        property_array = split(property{:}, '.');
        
        % Property in the table that includes dot should be read differently
        if length(property_array) > 1
            experiment.(property_array{1}).(property_array{2}) = block(obj.trial_index,:).(property{:}); 
        else
            experiment.(property{:}) = block(obj.trial_index, :).(property{:});
        end

    end

end

