classdef (Abstract) CFS < handle
    %CFS The interface class for three types of Continuous Flash Suppression
    %experiments: Breaking-CFS, Visual Priming and Visual Adaptation.
    % These are implemented in subclasses BCFS, VPCFS and VACFS, respectively.
    %
    % CFS Properties:
    %   waitframe - number of frames to wait when specifying good timing.
    %   target_images_path - directory with target images.
    %   cfs_mask_duration - duration of suppressing pattern in seconds.
    %   left_suppression - half of the screen on which suppressing pattern is shown.
    %   stimulus_position - positions of the stimulus.
    %   stimulus_size - size of the stimulus from 0 to 1 in percents.
    %   stimulus_rotation - rotation in degrees.
    %   stimulus_contrast - opaqueness from 0 to 1.
    %   stimulus_appearance_delay - appearance delay in seconds.
    %   stimulus_fade_in_duration - duration of stimulus fade-in.
    %   mask_position - position of the mask.
    %   mask_size - size of the mask from 0 to 1 in percents.
    %   mask_contrast - opaqueness from 0 to 1.
    %
    % CFS Methods:
    %  Public:
    %   initiate - initiates Psychtoolbox window and makes basic calculations.
    %   generate_mondrians - asynchronously runs static make_mondrian_masks function.
    %   generate_textures - generates textures from mondrian masks.
    %   import_target_images - loads images from dir path and makes an array of textures from it.
    %   introduction - shows introduction screen.
    %   get_rects - calculates on-screen coordinates based on given parameters.
    %   run_the_experiment - flips the screen.
    %  Protected and Static:
    %   initiate_window - calls basic Psychtoolbox settings and initiates window.
    %   get_stimulus_position - calculates on-screen coordinates based on given parameters. 
    %   make_mondrian_masks - generates an array of masks.

    properties

        % Number of frames to wait when specifying good timing.
        % For example, by using waitframe = 2 one would flip on every other frame. 
        % By using waitframe = 1 - every frame.
        % By using waitframe = 60 - every second (assuming that monitor's 
        % refresh rate is equal to 60Hz).
        % Relation between waitframe (WF) and temporal frequency (TF) [Hz]
        % is TF=RR/WF
        % RR[Hz] (Refresh rate) = refresh rate of the monitor. 
        waitframe double {mustBePositive, mustBeInteger} = 60;

        % Path to directory with target images.
        target_images_path {mustBeFolder} = './Images/Target_images';

        % Duration of suppressing pattern in seconds.
        cfs_mask_duration {mustBePositive, mustBeNumeric} = 5; 
        
        % Half of the screen on which suppressing pattern is shown.
        % By default (false) suppressing pattern is on the right half of the window; true/false.
        left_suppression logical {mustBeNumericOrLogical} = false; 
        
        % Expected values are 'UpperLeft', 'Top', 'UpperRight', 'Left', 
        % 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
        stimulus_position {mustBeMember(stimulus_position, { ...
                         'UpperLeft', 'Top', 'UpperRight', ...
                         'Left', 'Center', 'Right', ...
                         'LowerLeft', 'Bottom', 'LowerRight'})} = 'Top';
        
        % From 0 to 1, where 1 means 100% of the screen (half of the window).
        stimulus_size {mustBeGreaterThan(stimulus_size, 0), ...
                     mustBeLessThanOrEqual(stimulus_size, 1)} = 0.5; 
        
        % Positive values represent clockwise rotation, 
        % negative values represent counterclockwise rotation.
        stimulus_rotation double = 0; 
        
        % Contrast is from 0 (fully transparent) to 1 (fully opaque).
        stimulus_contrast {mustBeGreaterThan(stimulus_contrast, 0), ...
                             mustBeLessThanOrEqual(stimulus_contrast, 1)} = 1; 
        
        % Delay after initation of the suppression pattern;
        stimulus_appearance_delay {mustBeNumeric} = 2; 
        
        % Duration of fading in from maximal transparency to stimulus_contrast.
        stimulus_fade_in_duration {mustBeNumeric} = 2; 
        
        % Expected values are 'UpperLeft', 'Top', 'UpperRight', 'Left', 
        % 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
        mask_position {mustBeMember(mask_position, { ...
                       'UpperLeft', 'Top', 'UpperRight', ...
                       'Left', 'Center', 'Right', ...
                       'LowerLeft', 'Bottom', 'LowerRight'})} = 'Top';
        
        % From 0 to 1, where 1 means 100% of the screen (half of the window).
        mask_size {mustBeGreaterThan(mask_size, 0), ...
                   mustBeLessThanOrEqual(mask_size, 1)} = 0.5; 
        
        % Contrast is from 0 = fully transparent to 1 = fully opaque.
        mask_contrast {mustBeGreaterThan(mask_contrast, 0), ...
                           mustBeLessThanOrEqual(mask_contrast, 1)} = 1;
        
        % Size of the arms of the fixation cross in pixels.
        fixation_cross_arm_length {mustBePositive} = 20;

        % Line width of the fixation cross in pixels.
        fixation_cross_line_width {mustBePositive} = 4;

        % First item in an array will be a method name; key names for the
        % response follow. For example, {'4AFC', '1!', '2@', '3#', '4$'}.
        % For available key names see KbName('KeyNames').
        objective_evidence = {'2AFC', 'LeftArrow', 'RightArrow'};
        subjective_evidence = {'PAS', '1!', '2@', '3#', '4$'};
        
        % Shape: 1 - squares, 2 - circles, 3 - diamonds.
        mondrian_shape = 1;
        % Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
        % for 4...15 see 'help CFS.generate_mondrians'.
        mondrian_color = 15;

        % VPCFS only
        prime_images_path = './Images/Prime_images';
        % VPCFS only
        target_presentation_duration = 0.7; 
        
        number_of_trials = 30;
        vbl; % Timestamp of the last screen flip.
        

        
    end
    
    properties (Access = protected)

        window; % Psychtoolbox window.
        screen_x_pixels; % Number of pixels on the x axis.
        screen_y_pixels; % Number of pixels on the y axis.
        x_center; % Half of pixels on the x axis.
        y_center; % Half of pixels on the x axis.

        % IFI[s] (Inter frame interval) = 1/RR = time between vertical monitor refreshes.
        % RR[Hz] (Refresh rate) = refresh rate of the monitor. 
        % WF[#] (Waitframes) = number of refreshes before next flip.
        % FS[s] (Flip secs) = WF*IFI = time between flips.
        % CMD[s] (CFS mask duration) = duration of the suppressing pattern.
        % M[#] (Masks number) = CMD/FS = CMD/(WF*IFI) = overall number of masks.
        inter_frame_interval;
        % M[#] (Masks number) = CMD/FS = CMD/(WF*IFI) = overall number of masks.
        masks_number {mustBeInteger, mustBePositive}; 
        masks_number_before_stimulus {mustBeInteger};
        masks_number_while_fade_in {mustBeInteger};
        
        masks; % An array of generated mondrian masks.
        textures; % Psychtoolbox textures of the generated masks
        target_textures; % Psychtoolbox textures of the stimulus images.
        prime_textures;
        stimulus; % Randomly chosen stimulus image.
        stimulus_rect; % Coordinates of stimulus position on the screen.
        masks_rect; % Coordinates of masks position on the screen.
        future; % Result of background generation of mondrian masks.
        response_records; % Table for responses
        current_trial = 0;
        tstart;
    end
        

    methods
        function initiate(obj)
            %initiate Initiates Psychtoolbox window and makes basic calculations. 
            % initiate(obj) gets screen resolution parameters, an inter frame interval and
            % a window variable, calculates number of masks to generate.
            % Uses static, protected method initiate_window()
            [obj.screen_x_pixels, obj.screen_y_pixels, obj.x_center, ...
                obj.y_center, obj.inter_frame_interval, obj.window ...
                ] = obj.initiate_window();
            % FS[s] (Flip secs) = WF*IFI = time between flips.
            % IFI[s] (Inter frame interval) = 1/refresh_rate = time between vertical monitor refreshes.
            % WF[#] (Waitframes) = number of refreshes before next flip.
            flip_secs = obj.waitframe*obj.inter_frame_interval;
            obj.masks_number = round(obj.cfs_mask_duration/flip_secs);
            obj.masks_number_before_stimulus = round(obj.stimulus_appearance_delay/flip_secs);
            obj.masks_number_while_fade_in = round(obj.stimulus_fade_in_duration/flip_secs);
            
            % Start mondrian masks generation.
            % The function takes two arguments: shape and color.
            % Shape: 1 - squares, 2 - circles, 3 - diamonds.
            % Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
            % for 4...15 see 'help CFS.generate_mondrians'.
            obj.generate_mondrians();
            
            % Show introduction screen while masks are being generated.
            obj.introduction();
            
            % Generate PTB textures
            obj.generate_textures();
            
            % Calculate stimulus and masks coordinates on screen.
            obj.get_rects();
            
            % Import images from the provided directory and make their PTB textures.
            obj.target_textures = obj.import_images(obj.target_images_path);
            if isequal(class(obj), 'VPCFS')
                obj.prime_textures = obj.import_images(obj.prime_images_path);
            end
            
            obj.initiate_response_struct();
        end
      

        introduction(obj)
        get_rects(obj);
        alternatives_forced_choice(obj);
        perceptual_awareness_scale(obj);
    end
    
    methods (Access = protected)
        function generate_mondrians(obj)
            %generate_mondrians Asynchronously runs static make_mondrian_masks function.
            % Takes two arguments: shape and color.
            % Shape: 1 - squares, 2 - circles, 3 - diamonds
            % Color: Black(Bk), Gray(G), Red(R), Green(Gn), Blue(B), Yellow(Y),
            % Orange(O), Cyan(C), Magenta(M), White(W), Purple(P), dark+color(dColor), light+color(lColor)
            % 1 - Bk/R/Gn/B/Y/C/M/W, 2 - grayscale, 
            % 3 - R/dR/Gn/dGn/B/dB/lB/Y/dY/M/C/dC/W/Bk/G/dP/O
            % 4 - R/dR/B/dB/lB/M/dC/Bk/dP/O,
            % 5 - purples, 6 - reds, 7 - blues, 8 - professional 1, 9 - professional 2,
            % 10 - appetizing: tasty, 11 - electric, 12 - dependable 1, 
            % 13 - dependable 2, 14 - earthy ecological natural, 15 - feminine
            % See also make_mondrian_masks, parfeval.
            obj.future = parfeval(backgroundPool, @obj.make_mondrian_masks, 1, ...
                         obj.screen_x_pixels/2, obj.screen_y_pixels, ...
                         obj.masks_number, obj.mondrian_shape, obj.mondrian_color);
        end

        function generate_textures(obj)
            %generate_textures Generates textures from mondrian masks.

            % Wait until generate_mondrians() finishes.
            wait(obj.future)
            % Get the generated masks
            obj.masks = fetchOutputs(obj.future);
            % Initiate an array.
            obj.textures = cell(1, obj.masks_number);
            % Generate the Psychtoolbox textures.
            for n = 1 : obj.masks_number
                obj.textures{n} = Screen('MakeTexture', obj.window, obj.masks{n});
            end
        end

        function choose_stimulus(obj)
            %choose_stimulus Chooses random image from the stimuli.
            obj.stimulus = obj.target_textures{randi(length(obj.target_textures),1)};
        end
        
        textures = import_images(obj, path);
        fixation_cross(obj)
        tstart = flash_masks_only(obj);
        stimulus_fade_in(obj)
        flash_masks_with_stimulus(obj);
    end

    methods (Static, Access = protected)
        [screen_x_pixels,screen_y_pixels, x_center, y_center, inter_frame_interval, window] = initiate_window();
        [x0, y0, x1, y1] = get_stimulus_position(ninth, size);
        masks = make_mondrian_masks(sz_x,sz_y,n_masks,shape,selection);
        [response, secs] = record_response(evidence);
    end
    
    methods (Abstract)
        run_the_experiment(obj);
    end

    methods (Abstract, Access = protected)
        initiate_response_struct(obj);
        append_trial_response(obj);
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

