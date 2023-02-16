function update(obj, cur_exp)
%UPDATE Update every trial with initialized experiment parameters.

    for block = 1:obj.n_blocks
        for trial = 1:size(obj.matrix{block}, 2)
            exp = obj.matrix{block}{trial};
            for prop = properties(exp)'
                % If a property hasn't been initalized - copy it from the 
                % current experiment
                if isempty(exp.(prop{:}))
                    exp.(prop{:}) = cur_exp.(prop{:});
                
                % Else update empty property's properties
                else
                    prop_list = metaclass(exp.(prop{:})).PropertyList;
                    for idx = 1:length(prop_list)
                        if isempty(exp.(prop{:}).(prop_list(idx).Name)) && ~prop_list(idx).Dependent
                            exp.(prop{:}).(prop_list(idx).Name) = cur_exp.(prop{:}).(prop_list(idx).Name);
                        end
                    end
                end
            end
        end
    end
end

