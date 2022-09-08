classdef (Abstract) CFS < handle
    %CFS The interface class for three types of Continuous Flash Suppression
    %experiments: Breaking-CFS, Visual Priming and Visual Adaptation.
    % These are implemented in subclasses BCFS, VPCFS and VACFS, respectively.
    %
    % CFS Properties:
    %     temporal_frequency - number of masks flashed per one second. 
    %     cfs_mask_duration - duration of suppressing pattern in seconds.
    %     load_masks_from_folder -  load pregenerated masks from folder? true/false
    %     masks_path - if previous parameter set to true - specify path, e.g. './Masks'
    %     mask_position - position of the mask.
    %     mask_size - from 0 to 1, where 1 means 100% of the screen (half of the window).
    %     mask_contrast - contrast from 0 = fully transparent to 1 = fully opaque.
    %     mondrian_shape - shape: 1 - squares, 2 - circles, 3 - diamonds.
    %     mondrian_color - color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors, for 4...15 see 'help CFS.generate_mondrians'.
    %     target_images_path - path to a directory with target images.
    %     stimulus_position - position of the stimulus.
    %     stimulus_size - from 0 to 1, where 1 means 100% of the screen (half of the window).
    %     stimulus_rotation - rotation in degrees.
    %     stimulus_contrast - contrast is from 0 (fully transparent) to 1 (fully opaque).
    %     stimulus_appearance_delay - delay after initation of the suppressing pattern.
    %     stimulus_fade_in_duration - duration of fading in from maximal transparency to stimulus_contrast.
    %     fixation_cross_duration - duration of the fixation cross in seconds.
    %     fixation_cross_arm_length - size of the arms of the fixation cross in pixels.
    %     fixation_cross_line_width - line width of the fixation cross in pixels.
    %     fixation_cross_color - color in hexadecimal color code (check this in google)
    %     objective_evidence - cell array for method name and keycodes.
    %     subjective_evidence - cell array for method name and keycodes.
    %     subject_response_directory - directory to save the subject response data in. 
    %     subject_info_directory - directory to save recorded subject info (age, hand, eye, etc.) in.
    %
    % CFS Methods:
    %     initiate - runs SubjectInfoApp, initiates Psychtoolbox window, generates mondrians and makes basic calculations.
    %     save_responses - save subject responses and subject info.
    %     run_the_experiment - main function for the experiment loop. Implemented in the subclasses.

    properties
        
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
        
        trial_matrices_path {mustBeFolder} = './TrialMatrices';

        %--------MASKS PARAMETERS-------%

        % Number of masks flashed per one second.
        temporal_frequency {mustBePositive} = 10;

        % Duration of suppressing pattern in seconds.
        cfs_mask_duration {mustBePositive} = 5;

        % Load pregenerated masks from folder? true/false 
        load_masks_from_folder {mustBeNumericOrLogical} = false;
        
        % If previous parameter set to true - specify path, e.g. './Masks'
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
        mondrian_color{mustBeInteger, mustBeInRange(mondrian_color, 1, 15)} = 15;


        %--------STIMULUS PARAMETERS-------%

        
        % Stimulus position on the screen (half of the window).
        % Expected values are 'UpperLeft', 'Top', 'UpperRight', 'Left', 
        % 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
        stimulus_position {mustBeMember(stimulus_position, { ...
                         'UpperLeft', 'Top', 'UpperRight', ...
                         'Left', 'Center', 'Right', ...
                         'LowerLeft', 'Bottom', 'LowerRight'})} = 'Top';
        
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

        stimulus_duration {mustBeNonnegative} = 2;
        
        %--------CHECKERBOARD FRAME PARAMETERS-------%
        % Length and width in pixels
        checker_rect_length {mustBePositive, mustBeInteger} = 35;
        checker_rect_width {mustBePositive, mustBeInteger} = 20;
        % Checkerboard frame color in hexadecimal color code (check this in google)
        % Array of two strings
        checker_color_codes = ["#FFFFFF", "'#000000'"];


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
        
        % First item in an array will be a method name followed by key names for 
        % the response. For example, {'4AFC', '1!', '2@', '3#', '4$'} or
        % {'2AFC', 'LeftArrow', 'RightArrow'} or
        % {'7AFC', '1!', '2@', '3#', '4$', '5%', '6^', '7&'}, etc.  :)
        % For available key names please check KbName('KeyNames') or KbDemo.
        objective_evidence = {'2AFC', 'LeftArrow', 'RightArrow'};
        subjective_evidence = {'PAS', '1!', '2@', '3#', '4$'};
        
        % Directory to save the subject response data.
        subject_response_directory = './!Results';
        
        % Directory to save recorded subject info (age, hand, eye, etc.)
        subject_info_directory = './!SubjectInfo';

        breakthrough_key = 'space';

        results;

    %end


    %properties (Access = protected)
        trial_matrices;
        number_of_blocks;

        subj_info; % Structure to store subject info input
        left_suppression % Half of the screen on which suppressing pattern is shown.
        contrasts; % Array of precalculated contrasts for stimulus fade-in 
        window; % Psychtoolbox window.
        screen_x_pixels; % Number of pixels on the x axis.
        screen_y_pixels; % Number of pixels on the y axis.
        x_center; % Half of pixels on the x axis.
        y_center; % Half of pixels on the x axis.
        
        fixation_cross_args; % Arguments for flashing left and right fixation crosses.

        % WF[#] (Waitframes) = RR/TF = number of the refreshes before next flip.
        % TF[Hz] (Temporal frequency) = RR/WF = number of flips per second.
        % IFI[s] (Inter frame interval) = 1/RR = time between vertical monitor refreshes.
        % RR[Hz] (Refresh rate) = refresh rate of the monitor. 
        % CMD[s] (CFS mask duration) = duration of the suppressing pattern.
        % M[#] (Masks number) = CMD/FS = CMD/(WF*IFI) = overall number of masks.
        waitframe;

        % IFI[s] (Inter frame interval) = 1/RR = time between vertical monitor refreshes.
        % RR[Hz] (Refresh rate) = refresh rate of the monitor. 
        inter_frame_interval;

        % M[#] (Masks number) = CMD/FS = CMD/(WF*IFI) = overall number of masks.
        % CMD[s] (CFS mask duration) = duration of the suppressing pattern.
        % WF[#] (Waitframes) = RR/TF = number of the refreshes before next flip.
        % IFI[s] (Inter frame interval) = 1/RR = time between vertical monitor refreshes (measured by PTB).
        masks_number {mustBeInteger, mustBePositive}; 
        masks_number_before_stimulus {mustBeInteger};
        masks_number_while_fade_in {mustBeInteger};
        masks_number_while_stimulus {mustBeInteger};
        cumul_masks_number_before_fade_out {mustBeInteger};
        mask_in;
        mask_out;
        delay;

        checker_rects;
        checker_colors;
      
        masks; % An array of generated mondrian masks.
        textures; % Psychtoolbox textures of the generated masks
        target_textures; % Psychtoolbox textures of the target images.
        
        stimulus; % Stimulus texture.
        stimulus_index;
        stimulus_rect; % Coordinates of stimulus position on the screen.
        masks_rect; % Coordinates of masks position on the screen.
        future; % Result of background generation of mondrian masks.
        records; % Table for responses
        current_trial = 1; % Number of the current trial running.
        current_block = 1; % Number of the current block running.
        vbl; % Timestamps for internal use and for recording last screen flip time.
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
        
        function shuffle_masks(obj)
            %shuffle_mask Shuffles provided textures.
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
        get_rects(obj);
        make_mondrian_masks(obj);
        textures = import_images(obj, path, varargin);

        %run_the_experiment
        load_parameters(obj, block);
        rest_screen(obj);
        fixation_cross(obj);
        flash(obj);
        m_alternative_forced_choice(obj);
        perceptual_awareness_scale(obj);
        
        get_breaking_time(obj);
        initiate_records_table(obj);
        append_trial_results(obj);
        save_response(obj);
        
    end


    methods (Static, Access = protected)
        function stimulus = choose_texture(textures)
            %choose_texture Chooses random texture from passed array.
            stimulus = textures{randi(length(textures),1)};
        end
        
        [x, seed] = randomise(number_of_elements, repeats);
        [screen_x_pixels,screen_y_pixels, x_center, y_center, inter_frame_interval, window] = initiate_window(background_color);
        [x0, y0, x1, y1] = get_stimulus_position(ninth, size);
        
        [response, secs] = record_response(evidence);   
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

