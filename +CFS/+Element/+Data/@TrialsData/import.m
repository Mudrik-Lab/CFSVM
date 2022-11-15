function import(obj, experiment)
% IMPORT Imports trial tables from the provided dirpath.

    
    % Load filenames
    files = dir(fullfile(obj.dirpath, strcat('*', obj.file_extension)));

    % Read the tables, while converting all char columns to strings.
    for n = 1:length(files)
        path = fullfile(files(n).folder, files(n).name);
        opts = detectImportOptions(path, VariableNamingRule='preserve');
        opts = opts.setvartype(find(strcmp(opts.VariableTypes, 'char')), 'string');
        obj.blocks{n}=readtable(path, opts);
    end
    
    % Get number of tables.
    obj.n_blocks = length(obj.blocks);

    % For every table in the folder
    for i = 1:obj.n_blocks
        
        % If there is no masks variables in the table, create column with
        % the values provided in the main.m or with the default ones.
        for var = obj.VARS_MASKS
            if ~ismember(var, obj.blocks{i}.Properties.VariableNames)
                obj.blocks{i}.(strcat('masks.',var))(:) = experiment.masks.(var);
            end
        end

        % If there is no stimulus variables in the table, create column with
        % the values provided in the main.m or with the default ones.
        for var = obj.VARS_STIMULUS
            if ~ismember(var, obj.blocks{i}.Properties.VariableNames)
                obj.blocks{i}.(strcat('stimulus.',var))(:) = experiment.stimulus.(var);
            end
        end
        
        % Check that provided times make sense, e.g. sum of stimulus times can't
        % be greater than the masks flashing time.
        if any(obj.blocks{i}{:, 'masks.duration'} - ...
                sum(obj.blocks{i}{:, strcat('stimulus.',obj.VARS_STIMULUS)}, 2) < 0)
            % Clear the screen.
            Screen('CloseAll');
            error('masks.duration parameter is smaller than the sum the of other timing parameters, please make sure your parameters make sense.')
        end
        
        % If indices for specific stimuli images are not provided, create
        % column with random indices. 
        % Check CFS.Element.Data.TrialsData.randomise function


        intratrial_stimuli_idx = cellfun(@(n) (~isempty(regexp(n, 'stimulus.index\d+', 'once'))), ...
            obj.blocks{1}.Properties.VariableNames);
        if any(intratrial_stimuli_idx)
            obj.blocks{i}.('stimulus.indices')(:) = num2cell(table2array(obj.blocks{i}(:, intratrial_stimuli_idx)), 2);
            obj.blocks{i} = removevars(obj.blocks{i}, intratrial_stimuli_idx);
        else
            obj.blocks{i}.('stimulus.indices')(:) = obj.randomise(experiment.stimulus.textures.len, height(obj.blocks{i}));
        end

        % Same thing for target stimulus indices.
        if (class(experiment) == "CFS.Experiment.VPCFS" || class(experiment) == "CFS.Experiment.VACFS") ...
                && ~ismember('target.index', obj.blocks{i}.Properties.VariableNames)
            obj.blocks{i}.('target.index')(:) = obj.randomise(experiment.target.textures.len, height(obj.blocks{i}));
        end
        
    end
    
end

