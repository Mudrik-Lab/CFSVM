function update(obj, experiment)
% Updates every trial with initialized experiment parameters.
%
% Used in :func:`~+CFS.+Experiment.@CFS.initiate` function.
%
% Args:
%   experiment: An experiment object to update properties in.

    for block = 1:obj.n_blocks
        for trial = 1:size(obj.matrix{block}, 2)
            exp = obj.matrix{block}{trial};
            for prop = properties(exp)'
                % If a property hasn't been initalized - copy it from the 
                % current experiment
                if isempty(exp.(prop{:}))
                    exp.(prop{:}) = experiment.(prop{:});
                
                % Else update empty property's properties
                else
                    prop_list = metaclass(exp.(prop{:})).PropertyList;
                    for idx = 1:length(prop_list)
                        if isempty(exp.(prop{:}).(prop_list(idx).Name)) && ~prop_list(idx).Dependent
                            exp.(prop{:}).(prop_list(idx).Name) = experiment.(prop{:}).(prop_list(idx).Name);
                        end
                    end
                end
            end
        end
    end
end

