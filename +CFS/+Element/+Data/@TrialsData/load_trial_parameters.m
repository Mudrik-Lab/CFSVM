function load_trial_parameters(obj, experiment)
%LOAD_TRIAL_PARAMETERS Summary of this function goes here
%   Detailed explanation goes here

    block = obj.blocks{obj.block_index};
    for property = block(obj.trial_index,:).Properties.VariableNames
        property_array = split(property{:}, '.');
        if length(property_array) > 1
            experiment.(property_array{1}).(property_array{2}) = block(obj.trial_index,:).(property{:}); 
        else
            experiment.(property{:}) = block(obj.trial_index, :).(property{:});
        end
    end
end

