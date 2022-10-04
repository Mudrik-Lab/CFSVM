function load_trial_matrix_row(obj)
%LOAD_TRIAL_MATRIX_ROW Summary of this function goes here
%   Detailed explanation goes here

    matrix = obj.trial_matrices{obj.results.block};
    for property = matrix(obj.results.trial,:).Properties.VariableNames
        obj.(property{:}) = matrix(obj.results.trial,:).(property{:});
    end
end

