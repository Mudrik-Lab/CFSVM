function initiate(obj)
    %initiate Initiates Psychtoolbox window, generates mondrians and runs other basic functions.
    % See also get_subject_info, initiate_window, read_trial_matrices, 
    % initiate_checkerboard_frame, make_mondrian_masks, introduction,
    % get_rect, import_images, initiate_records_table
    

    % Initiate PTB window and keep the data from it.
    [obj.window, obj.inter_frame_interval] = obj.initiate_window(CFS.hex2rgb(obj.background_color));

    for i = 1:length(obj.checker_color_codes)
        obj.checker_color_codes{i} = CFS.hex2rgb(obj.checker_color_codes{i})';
    end
    
    obj.initiate_checkerboard_frame();
    
    obj.adjust_screens();
    
    DrawFormattedText(obj.window, 'Preparing the experiment, please wait', 'center', 'center');
    Screen('Flip', obj.window);

    obj.initiate_screens();

    % Warm GetSecs() and WaitSecs() functions;
    GetSecs();
    WaitSecs(0.00001);

    % Import images from the provided directory and make their PTB textures.
    obj.target_textures = obj.import_images(obj.target_images_path);

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

    obj.import_trial_matrices();


    obj.initiate_response_functions();

    
    
    

    obj.write_subject_info();

    % Initiate structure for the subject responses
    obj.initiate_records_table();
    
    % If load-pregenerated-masks-from-folder set to true, then load the mask images,
    % create textures and run the introductory screen. 
    % If set to false, then generate mondrians with provided parameters,
    % run the introductory screen and create textures.
    if ~isfolder(obj.masks_path)
        % Start mondrian masks generation.
        % The function takes two arguments: shape and color.
        % Shape: 1 - squares, 2 - circles, 3 - diamonds.
        % Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
        % for 4...15 see 'help CFS.asynchronously_generate_mondrians'.
        obj.make_mondrian_masks();
    end
    % Create PTB textures of mondrians
    obj.textures = obj.import_images(obj.masks_path, obj.masks_number);

    % Show introduction screen.
    obj.introduction();
end
