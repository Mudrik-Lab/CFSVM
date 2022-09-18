classdef (Abstract) CFS < handle
    %CFS The interface class for three types of Continuous Flash Suppression
    %experiments: Breaking-CFS, Visual Priming and Visual Adaptation.
    % These are implemented in subclasses BCFS, VPCFS and VACFS, respectively.
    %
    % CFS Properties:
    %     background_color - background color in hexadecimal color code.
    %     target_images_path - path to a directory with target images.
    %     trial_matrices_path - path to a directory with trial matrices.
    %
    %     temporal_frequency - number of masks flashed per one second. 
    %     mask_duration - duration of suppressing pattern in seconds.
    %     masks_path - if previous parameter set to true - specify path, e.g. './Masks'
    %     mask_position - position of the mask.
    %     mask_size - from 0 to 1, where 1 means 100% of the screen (half of the window).
    %     mask_contrast - contrast from 0 = fully transparent to 1 = fully opaque.
    %     mondrian_shape - shape: 1 - squares, 2 - circles, 3 - diamonds.
    %     mondrian_color - color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors, for 4...15 see 'help CFS.generate_mondrians'.
    %
    %     stimulus_position - position of the stimulus.
    %     stimulus_size - from 0 to 1, where 1 means 100% of the screen (half of the window).
    %     stimulus_rotation - rotation in degrees.
    %     stimulus_contrast - contrast is from 0 (fully transparent) to 1 (fully opaque).
    %     stimulus_appearance_delay - delay after initation of the suppressing pattern.
    %     stimulus_fade_in_duration - duration of fading in from maximal transparency to stimulus_contrast.
    %     stimulus_duration - duration of stimulus between fade-in and fade-out
    %
    %     checker_rect_length - checkerboard frame rectangular element length.
    %     checker_rect_width - checkerboard frame rectangular element width.
    %     checker_color_codes - checkerboard frame colors in cell array with hex codes.
    %
    %     fixation_cross_duration - duration of the fixation cross in seconds.
    %     fixation_cross_arm_length - size of the arms of the fixation cross in pixels.
    %     fixation_cross_line_width - line width of the fixation cross in pixels.
    %     fixation_cross_color - color in hexadecimal color code (check this in google)
    %
    %     mAFC_keys - cell array for PTB keycodes.
    %     is_mAFC_text_version - boolean parameter to set mAFC function type.
    %     mAFC_images_size - from 0 to 1, where 1 means complete fill of x axis by the images. 
    %     PAS_keys - cell array for PTB keycodes.
    %     subject_response_directory - directory to save the subject response data in. 
    %     subject_info_directory - directory to save recorded subject info (age, hand, eye, etc.) in.
    %  
    %     breakthrough_key - input key to interpret as breaking in bCFS.
    %     results - struct with timings and responses.
    %
    % CFS Methods:
    %     get_subject_info - runs SubjectInfoApp to record subject info.
    %     initiate - initiates Psychtoolbox window, generates mondrians and makes other basic calculations.
    %     read_trial_matrices - imports trial matices data.
    %     run_the_experiment - main function for the experiment loop. Implemented in the subclasses.

    properties
        
        left_side_screen = [0, 0, 960, 1080];
        right_side_screen = [960, 0, 1920, 1080];
        % Background color in hexadecimal color code (check this in google)
        background_color = '#B54B34';
        
        % Path to a directory with target images. 
        % Please be aware of the nomenclature:
        % For BCFS - target images (stimuli) are shown with mondrians.
        % For VPCFS - prime images (stimuli) are shown with mondrians,
        % whereas target images are shown succeeding them w/o suppression.
        % For VACFS - adapter images (stimuli) are shown with mondrians, 
        % whereas target images are used for mAFC.
        target_images_path {mustBeFolder} = './Images/Target_images';
        
        % Path to a directory with trial matrices.
        trial_matrices_path {mustBeFolder} = './TrialMatrices';

        %--------MASKS PARAMETERS-------%

        % Number of masks flashed per one second.
        temporal_frequency {mustBePositive} = 10;

        % Duration of suppressing pattern in seconds.
        mask_duration {mustBePositive} = 5;
        
        % Path to a directory with pregenerated masks.
        masks_path = './Masks';

        % Masks position on the screen (half of the window).
        % Expected values are 'UpperLeft', 'Top', 'UpperRight', 'Left', 
        % 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
        mask_position {mustBeMember(mask_position, { ...
                       'UpperLeft', 'Top', 'UpperRight', ...
                       'Left', 'Center', 'Right', ...
                       'LowerLeft', 'Bottom', 'LowerRight'})} = 'Top';
        
        % From 0 to 1, where 1 means 100% of the screen (half of the window).
        mask_size {mustBeInRange(mask_size, 0, 1)} = 0.5; 
        
        % Contrast is from 0 = fully transparent to 1 = fully opaque.
        mask_contrast {mustBeInRange(mask_contrast, 0, 1)} = 1;

        % Shape: 1 - squares, 2 - circles, 3 - diamonds.
        mondrian_shape {mustBeInteger, mustBeInRange(mondrian_shape, 1, 3)} = 1;

        % Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
        % for 4...15 see 'help CFS.generate_mondrians'.
        mondrian_color {mustBeInteger, mustBeInRange(mondrian_color, 1, 15)} = 15;


        %--------STIMULUS PARAMETERS-------%

        
        % Stimulus position on the screen (half of the window).
        % Expected values are 'UpperLeft', 'Top', 'UpperRight', 'Left', 
        % 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
        stimulus_position {mustBeMember(stimulus_position, { ...
                         'UpperLeft', 'Top', 'UpperRight', ...
                         'Left', 'Center', 'Right', ...
                         'LowerLeft', 'Bottom', 'LowerRight'})} = 'Top';
        
        stimulus_xy_ratio = 1;

        % From 0 to 1, where 1 means 100% of the screen (half of the window).
        stimulus_size {mustBeInRange(stimulus_size, 0, 1)} = 0.5; 
        
        % Positive values represent clockwise rotation, 
        % negative values represent counterclockwise rotation.
        stimulus_rotation {mustBeNumeric} = 0; 
        
        % Contrast is from 0 (fully transparent) to 1 (fully opaque).
        stimulus_contrast {mustBeInRange(stimulus_contrast, 0, 1)} = 1; 
        
        % Delay after initation of the suppressing pattern;
        stimulus_appearance_delay {mustBeNonnegative} = 2; 
        
        % Duration of fading in from maximal transparency to stimulus_contrast.
        stimulus_fade_in_duration {mustBeNonnegative} = 2;
        
        % Duration of stimulus between fade-in and fade-out in seconds.
        stimulus_duration {mustBeNonnegative} = 2;
        
        %--------CHECKERBOARD FRAME PARAMETERS-------%

        % Checkerboard frame rectangular element length in pixels.
        checker_rect_length {mustBePositive, mustBeInteger} = 35;
        
        % Checkerboard frame rectangular element width in pixels.
        checker_rect_width {mustBePositive, mustBeInteger} = 20;

        % Checkerboard frame color in hexadecimal color code (check this in google)
        % Cell array of character vectors, e.g. {'#0072BD', '#D95319', '#EDB120', '#7E2F8E'}
        checker_color_codes = {'#FFFFFF', '#000000'};


        %--------FIXATION CROSS PARAMETERS-------%

        % In seconds
        fixation_cross_duration {mustBeNonnegative} = 2;

        % Size of the arms of the fixation cross in pixels.
        fixation_cross_arm_length {mustBePositive} = 20;

        % Line width of the fixation cross in pixels.
        fixation_cross_line_width {mustBePositive} = 4;

        % Fixation cross color in hexadecimal color code (check this in google)
        fixation_cross_color = '#36C8CF';


        %--------SUBJECT RESPONSE PARAMETERS-------%
        
        % Key names for recorded as the response. 
        % For example, {'LeftArrow', 'RightArrow'} or
        % {'1!', '2@', '3#', '4$', '5%', '6^', '7&'}, etc.
        % For available key names please check KbName('KeyNames') or KbDemo.
        mAFC_keys = {'LeftArrow', 'RightArrow'};
        
        % Set true if you want to use only text choices in mAFC.
        is_mAFC_text_version {mustBeNumericOrLogical} = false;
        
        % From 0 to 1, where 1 means complete fill of x axis by the images. 
        % y is rescaled automatically.
        mAFC_images_size {mustBeInRange(mAFC_images_size, 0, 1)} = 0.5;
        
        % Key names for recorded as the response. 
        % For example, {'LeftArrow', 'RightArrow'} or
        % {'1!', '2@', '3#', '4$', '5%', '6^', '7&'}, etc.
        % For available key names please check KbName('KeyNames') or KbDemo.
        PAS_keys = {'1!', '2@', '3#', '4$'};
        
        % Directory to save the subject response data.
        subject_response_directory = './!Results';
        
        % Directory to save recorded subject info (age, hand, eye, etc.)
        subject_info_directory = './!SubjectInfo';
        
        %--------OTHER PARAMETERS-------%
        % Input key to interpret as breaking in bCFS.
        breakthrough_key = 'space';

        % Struct for recording timings and responses.
        results;

    end


    properties (Access = protected)
        subj_info; % Structure to store subject info input
        trial_matrices; % Cell array of tables for provided trial tables.
        number_of_blocks {mustBeInteger, mustBePositive}; % Number of experiment blocks.
        left_suppression {mustBeNumericOrLogical}; % Half of the screen on which suppressing pattern is shown.
        
        textures; % Psychtoolbox textures of mondrian masks.
        target_textures; % Psychtoolbox textures of target images.
        stimulus; % Stimulus texture.
        stimulus_index; % Stimulus index.
        stimulus_rect; % Coordinates of stimulus position on the screen.
        stimulus_left_rect;
        stimulus_right_rect;
        contrasts; % Array of precalculated contrasts for stimulus fade-in 
        masks_rect; % Coordinates of masks position on the screen.
        mask_indices_while_fade_in; % Array with precalculated indicies for flashing masks.
        mask_indices_while_fade_out; % Array with precalculated indicies for flashing masks.
        checker_rects; % Array of both left and right checkerboard frame rectangles.
        checker_colors; % Array of both left and right checkerboard frame colors.
        fixation_cross_args; % PTB Screen('DrawLines') arguments for flashing left and right fixation crosses.
        
        window; % Psychtoolbox window.
        screen_x_pixels {mustBeInteger, mustBePositive}; % Number of pixels on the x axis.
        screen_y_pixels {mustBeInteger, mustBePositive}; % Number of pixels on the y axis.
        x_center {mustBeInteger, mustBePositive}; % Half of pixels on the x axis.
        y_center {mustBeInteger, mustBePositive}; % Half of pixels on the x axis.
        left_screen_x_pixels;
        left_screen_y_pixels;
        right_screen_x_pixels;
        right_screen_y_pixels;
        left_screen_x_center;
        left_screen_y_center;
        right_screen_x_center;
        right_screen_y_center;
        

        % WF[#] (Waitframes) = RR/TF = number of the refreshes before next flip.
        % TF[Hz] (Temporal frequency) = RR/WF = number of flips per second.
        % IFI[s] (Inter frame interval) = 1/RR = time between vertical monitor refreshes.
        % RR[Hz] (Refresh rate) = refresh rate of the monitor. 
        % CMD[s] (CFS mask duration) = duration of the suppressing pattern.
        % M[#] (Masks number) = CMD/FS = CMD/(WF*IFI) = overall number of masks.
        waitframe;
        % IFI[s] (Inter frame interval) = 1/RR = time between vertical monitor refreshes.
        % RR[Hz] (Refresh rate) = refresh rate of the monitor.
        % IFI is measured directly by Screen('GetFlipInterval', window) function.
        inter_frame_interval;
        % Delay between screen flips. 
        % Check this out for more information
        % https://stackoverflow.com/questions/38014908/explaning-a-line-in-code-from-psychtoolbox-tutorial?newreg=448c933d0ee34bbcaffb66576c1be751
        % obj.delay = 1/TF - 0.5*IFI ≈ IFI*(WF-0.5)
        delay {mustBePositive}; 
        % M[#] (Masks number) = CMD/(WF*IFI) = overall number of masks.
        % CMD[s] (CFS mask duration) = duration of the suppressing pattern.
        % WF[#] (Waitframes) = RR/TF = number of the refreshes before next flip.
        % IFI[s] (Inter frame interval) = 1/RR = time between vertical monitor refreshes (measured by PTB).
        masks_number {mustBeInteger, mustBePositive}; 
        masks_number_before_stimulus {mustBeInteger};
        masks_number_while_fade_in {mustBeInteger};
        masks_number_while_stimulus {mustBeInteger};
        cumul_masks_number_before_fade_out {mustBeInteger};
        
        % Function handle for m_alternative_forced_choice(obj) or 
        % m_alternative_forced_choice_text(obj)
        mAFC;
        % Get the number from the length of mAFC_keys parameter.
        number_of_mAFC_pictures {mustBePositive, mustBeInteger};
        % Get the number from the length of PAS_keys parameter.
        number_of_PAS_choices {mustBePositive, mustBeInteger};
        
    
        records; % Table for responses
        current_trial = 1; % Number of the current trial running.
        current_block = 1; % Number of the current block running.
        vbl; % Timestamp for internal use.
    end
    

    methods
        get_subject_info(obj);
        initiate(obj);
        read_trial_matrices(obj);
    end
    

    methods (Abstract)
        run_the_experiment(obj);
    end


    methods (Access = protected) 
        
        function shuffle_masks(obj, seed)
            %shuffle_mask Shuffles provided textures with seed.
            rng(seed);
            obj.textures = obj.textures(randperm(length(obj.textures)));
        end

        function create_KbQueue(obj)
            %create_KbQueue Creates PTB KbQueue, see PTB documentation.
            keys=[KbName(obj.breakthrough_key)]; % All keys on right hand plus trigger, can be found by running KbDemo
            keylist=zeros(1,256); % Create a list of 256 zeros
            keylist(keys)=1; % Set keys you interested in to 1
            KbQueueCreate(-1,keylist); % Create the queue with the provided keys
        end

        %initiate
        introduction(obj);
        make_mondrian_masks(obj);
        textures = import_images(obj, path, varargin);
        initiate_checkerboard_frame(obj);
        initiate_records_table(obj);

        %run_the_experiment
        load_parameters(obj, block);
        rest_screen(obj);
        fixation_cross(obj);
        flash(obj);
        m_alternative_forced_choice(obj);
        m_alternative_forced_choice_text(obj);
        perceptual_awareness_scale(obj);
        get_breaking_time(obj);
        append_trial_results(obj);
        save_response(obj);
        
    end


    methods (Static, Access = protected)
        [x, seed] = randomise(number_of_elements, repeats);
        [screen_x_pixels,screen_y_pixels, x_center, y_center, inter_frame_interval, window] = initiate_window(background_color);
        [x0, y0, x1, y1, i, j] = get_stimulus_position(ninth, size);
        [response, secs] = record_response(evidence);
        rect = get_rect(side_screen_rect, shift, position, size, xy_ratio);
    end  

    
    methods (Hidden)
        function varargout = findobj(O,varargin)
            varargout = findobj@handle(O,varargin{:});
        end
        function varargout = findprop(O,varargin)
            varargout = findprop@handle(O,varargin{:});
        end
        function varargout = addlistener(O,varargin)
            varargout = addlistener@handle(O,varargin{:});
        end
        function varargout = notify(O,varargin)
            varargout = notify@handle(O,varargin{:});
        end
        function varargout = listener(O,varargin)
            varargout = listener@handle(O,varargin{:});
        end
        function varargout = delete(O,varargin)
            varargout = delete@handle(O,varargin{:});
        end
    end

end

