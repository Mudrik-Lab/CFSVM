function import_trial_matrices(obj)
%IMPORT_TRIAL_MATRICES Summary of this function goes here
%   Detailed explanation goes here
    
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

    vars = ["temporal_frequency", "mask_duration" ...
        "stimulus_appearance_delay", "stimulus_fade_in_duration", ...
        "stimulus_duration", "stimulus_fade_out_duration"];
    for i=1:length(obj.trial_matrices)
        
        for parameter = vars
            if ~ismember(parameter, obj.trial_matrices{i}.Properties.VariableNames)
                obj.trial_matrices{i}.(parameter)(:) = obj.(parameter);
            end
        end
        
        if any(obj.trial_matrices{i}{:, vars(2)} - sum(obj.trial_matrices{i}{:, vars(3:end)},2) < 0)
            % Clear the screen.
            Screen('CloseAll');
            error('mask_duration parameter is smaller than sum of other timing parameters, please make sure your parameters make sense.')
        end
        
        if ~ismember('stimulus_index', obj.trial_matrices{i}.Properties.VariableNames)
            switch class(obj)
                case 'VPCFS'
                    obj.trial_matrices{i}.('stimulus_index')(:) = obj.randomise(length(obj.prime_textures), height(obj.trial_matrices{i}));
                case 'BCFS'
                    obj.trial_matrices{i}.('stimulus_index')(:) = obj.randomise(length(obj.target_textures), height(obj.trial_matrices{i}));
                case 'VACFS'
                    obj.trial_matrices{i}.('stimulus_index')(:) = obj.randomise(length(obj.adapter_textures), height(obj.trial_matrices{i}));
            end
        
        end


        obj.trial_matrices{i}.masks_number = obj.trial_matrices{i}.temporal_frequency.*obj.trial_matrices{i}.mask_duration;

        obj.trial_matrices{i}.masks_number_before_stimulus = ...
            obj.trial_matrices{i}.temporal_frequency.*obj.trial_matrices{i}.stimulus_appearance_delay+1;

        obj.trial_matrices{i}.masks_number_while_fade_in = ...
            obj.trial_matrices{i}.temporal_frequency.*obj.trial_matrices{i}.stimulus_fade_in_duration;

        obj.trial_matrices{i}.masks_number_while_stimulus = ...
            obj.trial_matrices{i}.temporal_frequency.*obj.trial_matrices{i}.stimulus_duration;

        obj.trial_matrices{i}.masks_number_while_fade_out = ...
            obj.trial_matrices{i}.temporal_frequency.*obj.trial_matrices{i}.stimulus_fade_out_duration;
    end
end

