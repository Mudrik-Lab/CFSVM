function extract_from_raw_vm(path_to_raw_trials, subject_code)
% Extracts timings and durations from the raw trial VSM/VTM records.
%
% Saves timings in !Results folder and durations in !Processed folder.
%
% Args:
%   subject_code: str
%

    trials = load_trials(path_to_raw_trials,subject_code);
    variables = get_variables(trials);
    tab = create_table(variables);
    tab = extract_data(trials, tab, variables, path_to_raw_trials, subject_code);
    exp = string(regexp(class(trials{1}.obj), 'V\wM', 'match'));
    process_data(tab, path_to_raw_trials, subject_code, exp)
    
end


function trials = load_trials(path_to_raw_trials, code)

    filenames = dir(sprintf("%s/%s/*.mat", path_to_raw_trials, code));
    filenames = {filenames(:).name};
    filenames = sort_nat(filenames);

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


function tab = extract_data(trials, tab, variables, path_to_raw_trials, code)
    for trial_idx = 1:length(trials)
        for object = variables
            for var = object{:}(2:end)
                data.(strcat(object{:}{1}, '_', var{:})) = trials{trial_idx}.obj.(object{:}{1}).(var{:});
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
