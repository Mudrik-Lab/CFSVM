function import(obj)
% Loads .mat file.

    obj.matrix = load(obj.filepath).trial_matrix;
    [~, obj.n_blocks] = size(obj.matrix);
    
end

