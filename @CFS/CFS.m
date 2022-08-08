classdef CFS < handle
    %CFS The interface class for three types of Continuous Flash Suppression
    %experiments: Breaking-CFS, Visual Priming and Visual Adaptation.
    % These are implemented in subclasses BCFS, VPCFS and VACFS, respectively.
    %
    % CFS Properties:
    %   waitframe - number of frames to wait when specifying good timing.
    %   target_images_path - directory with target images.
    %   cfs_mask_duration - duration of suppressing pattern in seconds.
    %   left_suppression - half of the screen on which suppressing pattern is shown.
    %   target_position - positions of the target.
    %   target_size - size of the target from 0 to 1 in percents.
    %   target_rotation - rotation in degrees.
    %   target_contrast - opaqueness from 0 to 1.
    %   target_appearance_delay - appearance delay in seconds.
    %   target_fade_in_duration - duration of target fade-in.
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
        waitframe double {mustBePositive, mustBeInteger} = 60;

        % Directory with target images.
        target_images_path {mustBeFolder} = './Images/Target_images';

        % Duration of suppressing pattern in seconds, 
        % basically means duration of the experiment.
        cfs_mask_duration {mustBePositive, mustBeNumeric} = 5; 
        
        % Half of the screen on which suppressing pattern is shown.
        % By default (false) suppressing pattern is on the right half of the window; true/false.
        left_suppression logical {mustBeNumericOrLogical} = false; 
        
        % Expected values are 'UpperLeft', 'Top', 'UpperRight', 'Left', 
        % 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
        target_position {mustBeMember(target_position, { ...
                         'UpperLeft', 'Top', 'UpperRight', ...
                         'Left', 'Center', 'Right', ...
                         'LowerLeft', 'Bottom', 'LowerRight'})} = 'Top';
        
        % From 0 to 1, where 1 means 100% of the screen (half of the window).
        target_size {mustBeGreaterThan(target_size, 0), ...
                     mustBeLessThanOrEqual(target_size, 1)} = 0.5; 
        
        % Positive values represent clockwise rotation, 
        % negative values represent counterclockwise rotation.
        target_rotation double = 0; 
        
        % Contrast is from 0 (fully transparent) to 1 (fully opaque).
        target_contrast {mustBeGreaterThan(target_contrast, 0), ...
                             mustBeLessThanOrEqual(target_contrast, 1)} = 1; 
        
        % Delay after initation of the suppression pattern;
        target_appearance_delay {mustBeNumeric} = 2; 
        
        % Duration of fading in from maximal transparency to target_contrast.
        target_fade_in_duration {mustBeNumeric} = 2; 
        
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
        
    %end
    
    %properties (Access = protected)

        window; % Psychtoolbox window
        screen_x_pixels; % Number of pixels on the x axis
        screen_y_pixels; % Number of pixels on the y axis
        x_center; % Half of pixels on the x axis
        y_center; % Half of pixels on the x axis

        % IFI[s] (Inter frame interval) = 1/RR = time between vertical monitor refreshes.
        % RR[Hz] (Refresh rate) = refresh rate of the monitor. 
        % WF[#] (Waitframes) = number of refreshes before next flip.
        % FS[s] (Flip secs) = WF*IFI = time between flips.
        % CMD[s] (CFS mask duration) = duration of the suppressing pattern.
        % M[#] (Masks number) = CMD/FS = CMD/(WF*IFI) = overall number of masks.
        inter_frame_interval;
        % M[#] (Masks number) = CMD/FS = CMD/(WF*IFI) = overall number of masks.
        masks_number {mustBeInteger, mustBePositive}; 
        masks_number_before_target {mustBeInteger};
        masks_number_while_fade_in {mustBeInteger};
        
        masks; % An array of generated mondrian masks.
        textures; % Psychtoolbox textures of the generated masks
        target_textures; % Psychtoolbox textures of the target images.
        target_rect; % Coordinates of target position on the screen
        masks_rect; % Coordinates of masks position on the screen
        future; % Result of background generation of mondrian masks.

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
            obj.masks_number_before_target = round(obj.target_appearance_delay/flip_secs);
            obj.masks_number_while_fade_in = round(obj.target_fade_in_duration/flip_secs);
        end

        function generate_mondrians(obj, shape, color)
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
                         obj.masks_number, shape, color);
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
        
        function import_target_images(obj)
            %import_target_images Loads images from dir path and makes an array of textures from it.

            % Load filenames
            target_images = dir(obj.target_images_path);
            % Remove '.' and '..' from the list of filenames
            target_images=target_images(~ismember({target_images.name},{'.','..'}));
            % Load image files and make textures from them
            for img = 1:length(target_images)
                try
                    target_image = imread(fullfile(...
                        target_images(img).folder, target_images(img).name));
                    obj.target_textures{img} = Screen('MakeTexture', obj.window, target_image);
                catch
                end
            end
        end

        introduction(obj)
        get_rects(obj);
        time_elapsed = run_the_experiment(obj);

    end

    methods (Static, Access = protected)

      [screen_x_pixels,screen_y_pixels, x_center, y_center, inter_frame_interval, window] = initiate_window();
      [x0, y0, x1, y1] = get_stimulus_position(ninth, size);
      masks = make_mondrian_masks(sz_x,sz_y,n_masks,shape,selection);

    end
end

