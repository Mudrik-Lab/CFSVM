function import(obj)
% IMPORT Imports trial tables from the provided dirpath.

    obj.matrix = load(fullfile(obj.dirpath, 'experiment.mat')).trial_matrix;
    [~, obj.n_blocks] = size(obj.matrix);
    
end

