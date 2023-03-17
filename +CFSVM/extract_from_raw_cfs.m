function extract_from_raw_cfs(subject_code)
%EXTRACT_FROM_RAW

    trials = load_trials(subject_code);
    set_times(trials)
    variables = get_variables(trials);
    tab = create_table(variables);
    tab = extract_data(trials, tab, variables, subject_code);
    exp = string(regexp(class(trials{1}.obj), '\w+CFS', 'match'));
    process_data(tab, subject_code, exp)
    
end


function trials = load_trials(code)

    filenames = dir(sprintf("!Raw/%s/*.mat", code));
    filenames = {filenames(:).name};
    filenames = sort_nat(filenames);

    trials = cell(1, length(filenames));
    for file_idx = 1:length(filenames)
        trials{file_idx} = load(sprintf("!Raw/%s/%s",code,filenames{file_idx}));
    end

end


function set_times(trials)
    for trial_idx = 1:length(trials) 
    
        exp = trials{trial_idx}.obj;
        trials{trial_idx}.obj.masks.onset = exp.vbl_recs(1);
        trials{trial_idx}.obj.masks.offset = exp.vbl_recs(end);
        n_fr = length(exp.vbl_recs);

        stimuli = regexp(properties(exp), 'stimulus(_\d)*', 'match', 'once');
        stimuli = sort(stimuli(~cellfun('isempty', stimuli)));

        for stim_idx = 1:length(stimuli)
    
            onset_fr = exp.(stimuli{stim_idx}).appearance_delay*exp.screen.frame_rate+1;
            
            full_fr = (exp.(stimuli{stim_idx}).appearance_delay+ ...
                exp.(stimuli{stim_idx}).fade_in_duration)*exp.screen.frame_rate+1;
            
            fade_out_fr = (exp.(stimuli{stim_idx}).appearance_delay+ ...
                exp.(stimuli{stim_idx}).fade_in_duration+ ...
                exp.(stimuli{stim_idx}).duration)*exp.screen.frame_rate+1;
            
            offset_fr = (exp.(stimuli{stim_idx}).appearance_delay+ ...
                exp.(stimuli{stim_idx}).fade_in_duration+ ...
                exp.(stimuli{stim_idx}).duration+ ...
                exp.(stimuli{stim_idx}).fade_out_duration)*exp.screen.frame_rate+1;
            
            if class(exp) == "CFSVM.Experiment.BCFS"
                trials{trial_idx}.obj.(stimuli{stim_idx}).onset = check_frames(onset_fr, n_fr, exp);
                trials{trial_idx}.obj.(stimuli{stim_idx}).full_contrast_onset = check_frames(full_fr, n_fr, exp);
                trials{trial_idx}.obj.(stimuli{stim_idx}).fade_out_onset = check_frames(fade_out_fr, n_fr, exp);
                trials{trial_idx}.obj.(stimuli{stim_idx}).offset = check_frames(offset_fr, n_fr, exp);
            else
                trials{trial_idx}.obj.(stimuli{stim_idx}).onset = exp.vbl_recs(onset_fr);
                trials{trial_idx}.obj.(stimuli{stim_idx}).full_contrast_onset = exp.vbl_recs(full_fr);
                trials{trial_idx}.obj.(stimuli{stim_idx}).fade_out_onset = exp.vbl_recs(fade_out_fr);
                trials{trial_idx}.obj.(stimuli{stim_idx}).offset = exp.vbl_recs(offset_fr);
            end
        end
    end
end

function time = check_frames(frame, n_fr, exp)
    if frame <= n_fr
        time = exp.vbl_recs(frame);
    else
        time = exp.vbl_recs(end);
    end
end

function variables = get_variables(trials)
    objects = {};
    variables = {};
    exp = trials{1}.obj;
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


function tab = extract_data(trials, tab, variables, code)
    for trial_idx = 1:length(trials)
        for object = variables
            for var = object{:}(2:end)
                data.(strcat(object{:}{1}, '_', var{:})) = trials{trial_idx}.obj.(object{:}{1}).(var{:});
            end
        end
        data = orderfields(data, tab.Properties.VariableNames);
        tab = [tab;struct2table(data, AsArray=true)];
    end
    if ~exist("!Results", 'dir')
        mkdir("!Results")
    end
    
    writetable(tab, ...
            fullfile("!Results", ...
                strcat(code, ".csv")))
end


function process_data(tab, code, exp)

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
        TP.(sprintf('%s_full_contrast_duration', stimuli{stim_idx})) = tab.(sprintf('%s_fade_out_onset', stimuli{stim_idx})) - tab.(sprintf('%s_full_contrast_onset', stimuli{stim_idx}));
        TP.(sprintf('%s_fade_in_duration', stimuli{stim_idx})) = tab.(sprintf('%s_full_contrast_onset', stimuli{stim_idx})) - tab.(sprintf('%s_onset', stimuli{stim_idx}));
        TP.(sprintf('%s_fade_out_duration', stimuli{stim_idx})) = tab.(sprintf('%s_offset', stimuli{stim_idx})) - tab.(sprintf('%s_fade_out_onset', stimuli{stim_idx}));
    end

    if exp=="BCFS"
        keys = dictionary(["1", "2", ""], ["Left", "Right", "0"]);
        TP.break_response = keys(tab.breakthrough_response_choice);
        TP.is_break_correct = TP.break_response == tab.stimulus_1_position;
        TP.break_response_time = tab.breakthrough_response_time - tab.masks_onset;
    elseif exp=="VPCFS"
        TP.target_duration = tab.target_offset - tab.target_onset;
        TP.target_image_name = tab.target_image_name;
        TP.target_index = tab.target_index;
        TP.pas_duration = tab.pas_response_time - tab.pas_onset;
        TP.pas_response_choice = tab.pas_response_choice;
        TP.mafc_duration = tab.mafc_response_time - tab.mafc_onset;
        TP.mafc_response_choice = tab.mafc_response_choice;
        if ismember('mafc_img_indices', tab.Properties.VariableNames)
            TP.mafc_img_indices = tab.mafc_img_indices;
        end
    end
    
    if ~exist("!Processed", 'dir')
        mkdir("!Processed")
    end
    
    writetable(TP, ...
            fullfile("!Processed", ...
                strcat(code, ".csv")))
end


function [cs,index] = sort_nat(c,mode)
    %sort_nat: Natural order sort of cell array of strings.
    % usage:  [S,INDEX] = sort_nat(C)
    %
    % where,
    %    C is a cell array (vector) of strings to be sorted.
    %    S is C, sorted in natural order.
    %    INDEX is the sort order such that S = C(INDEX);
    %
    % Natural order sorting sorts strings containing digits in a way such that
    % the numerical value of the digits is taken into account.  It is
    % especially useful for sorting file names containing index numbers with
    % different numbers of digits.  Often, people will use leading zeros to get
    % the right sort order, but with this function you don't have to do that.
    % For example, if C = {'file1.txt','file2.txt','file10.txt'}, a normal sort
    % will give you
    %
    %       {'file1.txt'  'file10.txt'  'file2.txt'}
    %
    % whereas, sort_nat will give you
    %
    %       {'file1.txt'  'file2.txt'  'file10.txt'}
    %
    % See also: sort
    % Version: 1.4, 22 January 2011
    % Author:  Douglas M. Schwarz
    % Email:   dmschwarz=ieee*org, dmschwarz=urgrad*rochester*edu
    % Real_email = regexprep(Email,{'=','*'},{'@','.'})
    % Set default value for mode if necessary.
    if nargin < 2
	    mode = 'ascend';
    end
    % Make sure mode is either 'ascend' or 'descend'.
    modes = strcmpi(mode,{'ascend','descend'});
    is_descend = modes(2);
    if ~any(modes)
	    error('sort_nat:sortDirection',...
		    'sorting direction must be ''ascend'' or ''descend''.')
    end
    % Replace runs of digits with '0'.
    c2 = regexprep(c,'\d+','0');
    % Compute char version of c2 and locations of zeros.
    s1 = char(c2);
    z = s1 == '0';
    % Extract the runs of digits and their start and end indices.
    [digruns,first,last] = regexp(c,'\d+','match','start','end');
    % Create matrix of numerical values of runs of digits and a matrix of the
    % number of digits in each run.
    num_str = length(c);
    max_len = size(s1,2);
    num_val = NaN(num_str,max_len);
    num_dig = NaN(num_str,max_len);
    for i = 1:num_str
	    num_val(i,z(i,:)) = sscanf(sprintf('%s ',digruns{i}{:}),'%f');
	    num_dig(i,z(i,:)) = last{i} - first{i} + 1;
    end
    % Find columns that have at least one non-NaN.  Make sure activecols is a
    % 1-by-n vector even if n = 0.
    activecols = reshape(find(~all(isnan(num_val))),1,[]);
    n = length(activecols);
    % Compute which columns in the composite matrix get the numbers.
    numcols = activecols + (1:2:2*n);
    % Compute which columns in the composite matrix get the number of digits.
    ndigcols = numcols + 1;
    % Compute which columns in the composite matrix get chars.
    charcols = true(1,max_len + 2*n);
    charcols(numcols) = false;
    charcols(ndigcols) = false;
    % Create and fill composite matrix, comp.
    comp = zeros(num_str,max_len + 2*n);
    comp(:,charcols) = double(s1);
    comp(:,numcols) = num_val(:,activecols);
    comp(:,ndigcols) = num_dig(:,activecols);
    % Sort rows of composite matrix and use index to sort c in ascending or
    % descending order, depending on mode.
    [~, index] = sortrows(comp);
    if is_descend
	    index = index(end:-1:1);
    end
    index = reshape(index,size(c));
    cs = c(index);
end
