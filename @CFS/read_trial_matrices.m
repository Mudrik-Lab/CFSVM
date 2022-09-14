function read_trial_matrices(obj)
%read_trial_matrices Imports trial matrices from files.

    % Load filenames
    matrices = dir(obj.trial_matrices_path);
    % Remove '.' and '..' from the list of filenames
    matrices=matrices(~ismember({matrices.name},{'.','..'}));
    for n=1:length(matrices)
        path = fullfile(matrices(n).folder, matrices(n).name);
        opts = detectImportOptions(path);
        opts = opts.setvartype(find(strcmp(opts.VariableTypes, 'char')), 'string');
        obj.trial_matrices{n}=readtable(path, opts);
    end
    obj.number_of_blocks = length(obj.trial_matrices);
    
end

