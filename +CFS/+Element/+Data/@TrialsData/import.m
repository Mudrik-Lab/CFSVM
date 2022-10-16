function import(obj, experiment)
%IMPORT Summary of this function goes here
%   Detailed explanation goes here
    
    % Load filenames
    files = dir(fullfile(obj.dirpath, strcat('*', obj.file_extension)));
    % Remove '.' and '..' from the list of filenames
    for n = 1:length(files)
        path = fullfile(files(n).folder, files(n).name);
        opts = detectImportOptions(path, VariableNamingRule='preserve');
        opts = opts.setvartype(find(strcmp(opts.VariableTypes, 'char')), 'string');
        obj.blocks{n}=readtable(path, opts);
    end
    
    obj.n_blocks = length(obj.blocks);


    for i = 1:obj.n_blocks
        
        for var = obj.VARS_MASKS
            if ~ismember(var, obj.blocks{i}.Properties.VariableNames)
                obj.blocks{i}.(strcat('masks.',var))(:) = experiment.masks.(var);
            end
        end

        for var = obj.VARS_STIMULUS
            if ~ismember(var, obj.blocks{i}.Properties.VariableNames)
                obj.blocks{i}.(strcat('stimulus.',var))(:) = experiment.stimulus.(var);
            end
        end
        
        if any(obj.blocks{i}{:, 'masks.duration'} - ...
                sum(obj.blocks{i}{:, strcat('stimulus.',obj.VARS_STIMULUS)}, 2) < 0)
            % Clear the screen.
            Screen('CloseAll');
            error('masks.duration parameter is smaller than the sum the of other timing parameters, please make sure your parameters make sense.')
        end
        
        if ~ismember('stimulus.index', obj.blocks{i}.Properties.VariableNames)
            obj.blocks{i}.('stimulus.index')(:) = obj.randomise(experiment.stimulus.textures.len, height(obj.blocks{i}));
        end
        
        if (class(experiment) == "CFS.Experiment.VPCFS" || class(experiment) == "CFS.Experiment.VACFS") ...
                && ~ismember('target.index', obj.blocks{i}.Properties.VariableNames)
            obj.blocks{i}.('target.index')(:) = obj.randomise(experiment.target.textures.len, height(obj.blocks{i}));
        end

    end
end

