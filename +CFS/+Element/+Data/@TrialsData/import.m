function import(obj)
% IMPORT Imports trials data.

    obj.matrix = load(obj.filepath).trial_matrix;
    [~, obj.n_blocks] = size(obj.matrix);
    
end

