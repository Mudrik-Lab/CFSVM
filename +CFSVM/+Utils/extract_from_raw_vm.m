function extract_from_raw_vm(path_to_raw_trials, subject_code)
% Extracts timings and durations from the raw trial VSM/VTM records.
%
% Saves timings and in ``Extracted`` folder and 
% durations in ``Processed`` folder.
%
% Args:
%   path_to_raw_trials (str): Path to the ``RawTrials`` folder.
%   subject_code (str): Subject code for directory to extract the data from.
%
    trials = load_trials(path_to_raw_trials,subject_code);
    variables = get_variables(trials);
    tab = create_table(variables);
    tab = extract_data(trials, tab, variables, path_to_raw_trials, subject_code);
    exp = string(regexp(class(trials{1}.experiment), 'V\wM', 'match'));
    process_data(tab, path_to_raw_trials, subject_code, exp)
    
end


function trials = load_trials(path_to_raw_trials, code)

    filenames = dir(sprintf("%s/%s/*.mat", path_to_raw_trials, code));
    filenames = {filenames(:).name};
    filenames = CFSVM.Utils.natsortfiles(filenames);

    trials = cell(1, length(filenames));
    for file_idx = 1:length(filenames)
        trials{file_idx} = load(sprintf( ...
            "%s/%s/%s", ...
            path_to_raw_trials, ...
            code, ...
            filenames{file_idx}));
    end

end


function variables = get_variables(trials)
    objects = {};
    variables = {};
    exp = trials{1}.experiment;
    props = properties(exp)';
    for prop_idx = 1:length(props)
        prop = props{prop_idx};
        if isprop(exp.(prop), 'RESULTS')
            objects = cat(2, objects, prop);
        end
    end
    for object_idx = 1:length(objects)
        object_vars = [objects{object_idx}, exp.(objects{object_idx}).RESULTS];
        variables = cat(2, variables, {object_vars});
    end
end


function tab = create_table(variables)
   object_and_vars = cellfun( ...
        @(x) strcat(x{1}, '_', x(2:end)), ...
        variables, ...
        UniformOutput=false);
    vars_to_table = horzcat(object_and_vars{:});
    tab = cell2table( ...
        cell(0, length(vars_to_table)), ...
        'VariableNames', ...
        vars_to_table); 
end


function tab = extract_data(trials, tab, variables, path_to_raw_trials, code)
    for trial_idx = 1:length(trials)
        for object = variables
            for var = object{:}(2:end)
                data.(strcat(object{:}{1}, '_', var{:})) = trials{trial_idx}.experiment.(object{:}{1}).(var{:});
            end
        end
        data = orderfields(data, tab.Properties.VariableNames);
        tab = [tab;struct2table(data, AsArray=true)];
    end
    if ~exist(strcat(path_to_raw_trials, "/../Extracted/", code), 'dir')
        mkdir(strcat(path_to_raw_trials, "/../Extracted/", code))
    end
    
    writetable(tab, ...
            fullfile(strcat(path_to_raw_trials, "/../Extracted/", code), ...
                strcat(code, "_extracted.csv")))
end


function process_data(tab, path_to_raw_trials, code, exp)

    stimuli = regexp(tab.Properties.VariableNames, 'stimulus(_\d)*', 'match', 'once');
    stimuli = sort(unique(stimuli(~cellfun('isempty', stimuli))));
    
    TP = table;

    TP.block_index = tab.trials_block_index;
    TP.trial_index = tab.trials_trial_index;
    TP.trial_start_time = tab.trials_start_time;
    TP.trial_end_time = tab.trials_end_time;
    TP.trial_duration = TP.trial_end_time - TP.trial_start_time;
    if exp=="VSM"
        TP.fixation_duration = tab.f_mask_onset - tab.fixation_onset;
        TP.f_mask_duration = tab.f_mask_offset - tab.f_mask_onset;
        TP.b_mask_duration = tab.b_mask_offset - tab.b_mask_onset;
        for stim_idx = 1:length(stimuli)
            TP.(sprintf('%s_image_name', stimuli{stim_idx})) = tab.(sprintf('%s_image_name', stimuli{stim_idx}));
            TP.(sprintf('%s_index', stimuli{stim_idx})) = tab.(sprintf('%s_index', stimuli{stim_idx}));
            TP.(sprintf('%s_position', stimuli{stim_idx})) = tab.(sprintf('%s_position', stimuli{stim_idx}));
            TP.(sprintf('%s_f_soa', stimuli{stim_idx})) = tab.f_mask_onset - tab.(sprintf('%s_onset', stimuli{stim_idx}));
            TP.(sprintf('%s_b_soa', stimuli{stim_idx})) = tab.b_mask_onset - tab.(sprintf('%s_onset', stimuli{stim_idx}));
            TP.(sprintf('%s_duration', stimuli{stim_idx})) = tab.(sprintf('%s_offset', stimuli{stim_idx})) - tab.(sprintf('%s_onset', stimuli{stim_idx}));
        end

    elseif exp=="VTM"
        TP.fixation_duration = tab.mask_onset - tab.fixation_onset;
        TP.mask_duration = tab.mask_offset - tab.mask_onset;  
        for stim_idx = 1:length(stimuli)
            TP.(sprintf('%s_image_name', stimuli{stim_idx})) = tab.(sprintf('%s_image_name', stimuli{stim_idx}));
            TP.(sprintf('%s_index', stimuli{stim_idx})) = tab.(sprintf('%s_index', stimuli{stim_idx}));
            TP.(sprintf('%s_position', stimuli{stim_idx})) = tab.(sprintf('%s_position', stimuli{stim_idx}));
            TP.(sprintf('%s_soa', stimuli{stim_idx})) = tab.mask_onset - tab.(sprintf('%s_onset', stimuli{stim_idx}));
            TP.(sprintf('%s_duration', stimuli{stim_idx})) = tab.(sprintf('%s_offset', stimuli{stim_idx})) - tab.(sprintf('%s_onset', stimuli{stim_idx}));
        end
    end



    TP.pas_duration = tab.pas_response_time - tab.pas_onset;
    TP.pas_response_choice = tab.pas_response_choice;
    TP.mafc_duration = tab.mafc_response_time - tab.mafc_onset;
    TP.mafc_response_choice = tab.mafc_response_choice;
    if ismember('mafc_img_indices', tab.Properties.VariableNames)
        TP.mafc_img_indices = tab.mafc_img_indices;
    end

    
    if ~exist(strcat(path_to_raw_trials, "/../Processed/"), 'dir')
        mkdir(strcat(path_to_raw_trials, "/../Processed/"))
    end
    
    writetable(TP, ...
            fullfile(strcat(path_to_raw_trials, "/../Processed/"), ...
                strcat(code, "_processed.csv")))
end

