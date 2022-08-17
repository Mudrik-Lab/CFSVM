function initiate(obj)
    %initiate Runs SubjectInfoApp, initiates Psychtoolbox window, generates mondrians and makes basic calculations.
    % Runs the introduction screen, creates PTB textures, imports stimulus
    % images and more.
    % See also get_subject_info, initiate_window, introduction,
    % asynchronously_generate_mondrians, create_mondrian_textures,
    % get_rects, import_images and initiate_response_struct
    
    % Show input dialog for subject info
    obj.get_subject_info();
    
    % Initiate PTB window and keep the data from it.
    [obj.screen_x_pixels, obj.screen_y_pixels, obj.x_center, ...
        obj.y_center, obj.inter_frame_interval, obj.window ...
        ] = obj.initiate_window(obj.background_color);
    % Calculate useful variables from the parameters provided by the user.
    obj.waitframe = Screen('NominalFrameRate', obj.window)/obj.temporal_frequency;
    obj.masks_number = obj.cfs_mask_duration*obj.temporal_frequency+1;
    obj.masks_number_before_stimulus = obj.stimulus_appearance_delay*obj.temporal_frequency+1;
    obj.masks_number_while_fade_in = obj.stimulus_fade_in_duration*obj.temporal_frequency;
    obj.contrasts = 0:1/(obj.waitframe*obj.temporal_frequency*obj.stimulus_fade_in_duration):obj.stimulus_contrast;
    
    % If load-pregenerated-masks-from-folder set to true, then load the mask images,
    % create textures and run the introductory screen. 
    % If set to false, then generate mondrians with provided parameters,
    % run the introductory screen and create textures.
    if obj.load_masks_from_folder == true
        obj.textures = obj.import_images(obj.masks_path, obj.masks_number);
        
        % Show introduction screen while masks are being generated.
        obj.introduction();
    
    else
        % Start mondrian masks generation.
        % The function takes two arguments: shape and color.
        % Shape: 1 - squares, 2 - circles, 3 - diamonds.
        % Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
        % for 4...15 see 'help CFS.asynchronously_generate_mondrians'.
        obj.asynchronously_generate_mondrians();
        
        % Show introduction screen while masks are being generated.
         obj.introduction();

        % Create PTB textures
       obj.create_mondrian_textures();
    end
    
    % Calculate stimulus and masks coordinates on screen.
    obj.get_rects();
    
    % Import images from the provided directory and make their PTB textures.
    obj.target_textures = obj.import_images(obj.target_images_path);
    
    % If the experiment type is set to Visual Priming, then import prime
    % images and create their textures as well.
    if isequal(class(obj), 'VPCFS')
        obj.prime_textures = obj.import_images(obj.prime_images_path);
    elseif isequal(class(obj), 'VACFS')
        obj.adapter_textures = obj.import_images(obj.adapter_images_path);
    end
    
    % Initiate structure for the subject responses
    obj.initiate_response_struct();
end
