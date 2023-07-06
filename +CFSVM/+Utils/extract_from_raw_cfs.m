function extract_from_raw_cfs(path_to_raw_trials, subject_code)
    % Extracts timings and durations from the raw trial bCFS/VPCFS records.
    %
    % Saves timings and a histogram of interframe intervals
    % in ``Extracted`` folder and durations in ``Processed`` folder.
    %
    % Args:
    %   path_to_raw_trials (str): path to the ``RawTrials`` folder.
    %   subject_code (str): Subject code for directory to extract the data from.
    %
    trials = load_trials(path_to_raw_trials, subject_code);
    set_times(trials);
    variables = get_variables(trials);
    tab = create_table(variables);
    tab = extract_data(trials, tab, variables, path_to_raw_trials, subject_code);
    process_data(tab, path_to_raw_trials, subject_code, trials);

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

function set_times(trials)
    for trial_idx = 1:length(trials)

        exp = trials{trial_idx}.experiment;
        trials{trial_idx}.experiment.masks.onset = exp.flips(2, 1);
        trials{trial_idx}.experiment.masks.offset = exp.flips(2, end);
        n_fr = length(exp.flips);

        stimuli = regexp(properties(exp), 'stimulus(_\d)*', 'match', 'once');
        stimuli = sort(stimuli(~cellfun('isempty', stimuli)));

        for stim_idx = 1:length(stimuli)

            onset_fr = find(exp.(stimuli{stim_idx}).indices, 1, 'first');
            offset_fr = find(exp.(stimuli{stim_idx}).indices, 1, 'last');

            if class(exp) == "CFSVM.Experiment.BCFS"
                trials{trial_idx}.experiment.(stimuli{stim_idx}).onset = check_frames(onset_fr, n_fr, exp);
                trials{trial_idx}.experiment.(stimuli{stim_idx}).offset = check_frames(offset_fr, n_fr, exp);
            else
                trials{trial_idx}.experiment.(stimuli{stim_idx}).onset = exp.flips(2, onset_fr);
                trials{trial_idx}.experiment.(stimuli{stim_idx}).offset = exp.flips(2, offset_fr);
            end
        end
    end
end

function time = check_frames(frame, n_fr, exp)
    if frame <= n_fr
        time = exp.flips(2, frame);
    else
        time = exp.flips(2, end);
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
                              UniformOutput = false);
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
        tab = [tab; struct2table(data, AsArray = true)];
    end

    if ~exist(strcat(path_to_raw_trials, "/../Extracted/", code), 'dir')
        mkdir(strcat(path_to_raw_trials, "/../Extracted/", code));
    end

    writetable(tab, ...
               fullfile(strcat(path_to_raw_trials, "/../Extracted/", code), ...
                        strcat(code, "_extracted.csv")));

    ifis = get_ifis(trials);
    save_ifis_histogram(ifis, path_to_raw_trials, code);

end

function save_ifis_histogram(ifis, path_to_raw_trials, code)
    f = figure('visible', 'off');
    ifis = horzcat(ifis{:});
    histogram(ifis);
    title(sprintf( ...
                  'Duration of interframe intervals for flashing\n mean = %f, std = %f', ...
                  [mean(ifis), std(ifis)]));
    xlabel('Interframe interval duration (sec)');
    ylabel('Count');
    saveas(f, strcat( ...
                     path_to_raw_trials, ...
                     "/../Extracted/", ...
                     code, ...
                     '/', ...
                     code, ...
                     '_ifis_histogram.png'));
end

function ifis = get_ifis(trials)
    ifis = cell(1, length(trials));
    for trial_idx = 1:length(trials)
        exp = trials{trial_idx}.experiment;
        ifi = exp.flips(2, 2:end) - exp.flips(2, 1:end - 1);
        ifis{trial_idx} = ifi;
    end
end

function process_data(tab, path_to_raw_trials, code, trials)

    exp = string(regexp(class(trials{1}.experiment), '\w+CFS', 'match'));

    stimuli = regexp(tab.Properties.VariableNames, 'stimulus(_\d)*', 'match', 'once');
    stimuli = sort(unique(stimuli(~cellfun('isempty', stimuli))));

    TP = table;

    TP.block_index = tab.trials_block_index;
    TP.trial_index = tab.trials_trial_index;
    TP.trial_start_time = tab.trials_start_time;
    TP.trial_end_time = tab.trials_end_time;
    TP.trial_duration = TP.trial_end_time - TP.trial_start_time;
    TP.masks_duration = tab.masks_offset - tab.masks_onset;
    TP.fixation_duration = tab.masks_onset - tab.fixation_onset;
    for stim_idx = 1:length(stimuli)
        TP.(sprintf('%s_image_name', stimuli{stim_idx})) = tab.(sprintf('%s_image_name', stimuli{stim_idx}));
        TP.(sprintf('%s_index', stimuli{stim_idx})) = tab.(sprintf('%s_index', stimuli{stim_idx}));
        TP.(sprintf('%s_position', stimuli{stim_idx})) = tab.(sprintf('%s_position', stimuli{stim_idx}));
        TP.(sprintf('%s_delay_duration', stimuli{stim_idx})) = tab.(sprintf('%s_onset', stimuli{stim_idx})) - tab.masks_onset;
        TP.(sprintf('%s_duration', stimuli{stim_idx})) = tab.(sprintf('%s_offset', stimuli{stim_idx})) - tab.(sprintf('%s_onset', stimuli{stim_idx}));
    end

    if exp == "BCFS"
        break_keys = trials{1}.experiment.breakthrough.keys;
        keys = dictionary([string(1:length(break_keys)), "-1"], [convertCharsToStrings(break_keys), "-1"]);
        TP.break_response_index = tab.breakthrough_response_choice;
        TP.break_response_key = keys(tab.breakthrough_response_choice);
        TP.break_response_time = tab.breakthrough_response_time - tab.masks_onset;
    elseif exp == "VPCFS"
        pas_keys = trials{1}.experiment.pas.keys;
        pas_keys = dictionary(string(0:length(pas_keys) - 1), convertCharsToStrings(pas_keys));
        mafc_keys = trials{1}.experiment.mafc.keys;
        mafc_keys = dictionary(string(1:length(mafc_keys)), convertCharsToStrings(mafc_keys));
        TP.target_duration = tab.target_offset - tab.target_onset;
        TP.target_image_name = tab.target_image_name;
        TP.target_index = tab.target_index;
        TP.pas_duration = tab.pas_response_time - tab.pas_onset;
        TP.pas_response_choice_index = tab.pas_response_choice;
        TP.pas_response_choice_key = pas_keys(tab.pas_response_choice);
        TP.mafc_duration = tab.mafc_response_time - tab.mafc_onset;
        TP.mafc_response_choice_index = tab.mafc_response_choice;
        TP.mafc_response_choice_key = mafc_keys(tab.mafc_response_choice);
        if ismember('mafc_img_indices', tab.Properties.VariableNames)
            TP.mafc_img_indices = tab.mafc_img_indices;
        end
    end

    if ~exist(strcat(path_to_raw_trials, "/../Processed/"), 'dir')
        mkdir(strcat(path_to_raw_trials, "/../Processed/"));
    end

    writetable(TP, ...
               fullfile(strcat(path_to_raw_trials, "/../Processed/"), ...
                        strcat(code, "_processed.csv")));
end
