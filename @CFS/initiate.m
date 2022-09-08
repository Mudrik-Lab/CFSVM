function initiate(obj)
    %initiate Runs SubjectInfoApp, initiates Psychtoolbox window, generates mondrians and makes basic calculations.
    % Runs the introduction screen, creates PTB textures, imports stimulus
    % images and more.
    % See also get_subject_info, initiate_window, introduction,
    % asynchronously_generate_mondrians, create_mondrian_textures,
    % get_rects, import_images and initiate_response_struct
    

    % Initiate PTB window and keep the data from it.
    [obj.screen_x_pixels, obj.screen_y_pixels, obj.x_center, ...
        obj.y_center, obj.inter_frame_interval, obj.window ...
        ] = obj.initiate_window(hex2rgb(obj.background_color));
    
    DrawFormattedText(obj.window, 'Preparing the experiment, please wait', 'center', 'center');
    Screen('Flip', obj.window);
    
    % Warm GetSecs() and WaitSecs();
    GetSecs();
    WaitSecs(0.00001);

    % If the experiment type is set to Visual Priming, then import prime
    % images and create their textures as well.
    if isequal(class(obj), 'VPCFS')
        obj.prime_textures = obj.import_images(obj.prime_images_path);
    else
        obj.create_KbQueue();
        if isequal(class(obj), 'VACFS')   
            obj.adapter_textures = obj.import_images(obj.adapter_images_path);
        end
    end

    % Import images from the provided directory and make their PTB textures.
    obj.target_textures = obj.import_images(obj.target_images_path);

    obj.read_trial_matrices();
    
    vars = ["cfs_mask_duration", "temporal_frequency", ...
        "stimulus_appearance_delay", "stimulus_fade_in_duration", ...
        "stimulus_duration"];
    for i=1:length(obj.trial_matrices)
        
        for parameter = vars
            if ~ismember(parameter, obj.trial_matrices{i}.Properties.VariableNames)
                obj.trial_matrices{i}.(parameter)(:) = obj.(parameter);
            end
        
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


        obj.trial_matrices{i}.masks_number = obj.trial_matrices{i}.temporal_frequency.*obj.trial_matrices{i}.cfs_mask_duration;

        obj.trial_matrices{i}.masks_number_before_stimulus = ...
            obj.trial_matrices{i}.temporal_frequency.*obj.trial_matrices{i}.stimulus_appearance_delay+1;

        obj.trial_matrices{i}.masks_number_while_fade_in = ...
            obj.trial_matrices{i}.temporal_frequency.*obj.trial_matrices{i}.stimulus_fade_in_duration;

        obj.trial_matrices{i}.masks_number_while_stimulus = ...
            obj.trial_matrices{i}.temporal_frequency.*obj.trial_matrices{i}.stimulus_duration;


    end

    max_temporal_frequency = max(cellfun(@(matrix) (max(matrix.temporal_frequency)), obj.trial_matrices));
    max_cfs_mask_duration = max(cellfun(@(matrix) (max(matrix.cfs_mask_duration)), obj.trial_matrices));
    obj.masks_number = max_temporal_frequency*max_cfs_mask_duration+1;
    
    % Calculate stimulus and masks coordinates on screen.
    obj.get_rects();
    
    for i = 1:length(obj.checker_color_codes)
        obj.checker_color_codes{i} = hex2rgb(obj.checker_color_codes{i})';
    end
    obj.checkerboard_frame();
    
    
    
    
    if ~exist(obj.subject_response_directory, 'dir')
        mkdir(obj.subject_response_directory);
    end
    if ~exist(obj.subject_info_directory, 'dir')
        mkdir(obj.subject_info_directory);
    end
    writetable(struct2table(obj.subj_info),sprintf('%s/%d.csv',obj.subject_info_directory, obj.subj_info.subject_code));


    % Initiate structure for the subject responses
    obj.initiate_records_table();
    
    % If load-pregenerated-masks-from-folder set to true, then load the mask images,
    % create textures and run the introductory screen. 
    % If set to false, then generate mondrians with provided parameters,
    % run the introductory screen and create textures.
    if obj.load_masks_from_folder == true
        % Create PTB textures of mondrians
        obj.textures = obj.import_images(obj.masks_path, obj.masks_number);
    else
        % Start mondrian masks generation.
        % The function takes two arguments: shape and color.
        % Shape: 1 - squares, 2 - circles, 3 - diamonds.
        % Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
        % for 4...15 see 'help CFS.asynchronously_generate_mondrians'.
        obj.make_mondrian_masks();
        % Create PTB textures of mondrians
        obj.textures = obj.import_images(obj.masks_path, obj.masks_number);
    end

    % Show introduction screen while masks are being generated.
        obj.introduction();

    
end

function rgb = hex2rgb(hex)
    %hex2rgb Transforms hexadecimal color code to MATLAB RGB color code.
    rgb = sscanf(hex(2:end),'%2x%2x%2x',[1 3])/255;
end
