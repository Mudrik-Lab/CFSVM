classdef CFS < handle
    %CFS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Number of frames to wait when specifying good timing. 
        % For example, by using waitframe = 2 one would flip on every other frame. 
        % By using waitframe = 1 - every frame.
        % By using waitframe = 60 - every second (assuming that monitor's 
        % refresh rate is equal to 60Hz).
        waitframe double {mustBePositive, mustBeInteger} = 60; 

        % Location of target image for import.
        target_images_path {mustBeFolder} = './Images/Target_images'; 

        % Duration of suppressing pattern in seconds, 
        % basically means duration of the experiment.
        cfs_mask_duration {mustBePositive, mustBeNumeric} = 5; 

        % By default (false) suppressing pattern is on the right half of the window; true/false.
        left_suppression logical {mustBeNumericOrLogical} = false; 
     
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
        
        % Contrast from 0 (fully transparent) to 1 (fully opaque).
        target_transparency {mustBeGreaterThan(target_transparency, 0), ...
                             mustBeLessThanOrEqual(target_transparency, 1)} = 1; 
        
        % Delay after initation of the suppression pattern;
        target_appearance_delay {mustBeNumeric} = 2; 
        
        % Duration of fading in from zero transparency to target_transparency.
        target_fade_in_duration {mustBeNumeric} = 2; 
        
        mask_position {mustBeMember(mask_position, { ...
                       'UpperLeft', 'Top', 'UpperRight', ...
                       'Left', 'Center', 'Right', ...
                       'LowerLeft', 'Bottom', 'LowerRight'})} = 'Top';
        
        % From 0 to 1, where 1 means 100% of the screen (half of the window).
        mask_size {mustBeGreaterThan(mask_size, 0), ...
                   mustBeLessThanOrEqual(mask_size, 1)} = 0.5; 
        
        % Range is 0 = fully transparent to 1 = fully opaque.
        mask_transparency {mustBeGreaterThan(mask_transparency, 0), ...
                           mustBeLessThanOrEqual(mask_transparency, 1)} = 1;
    %end
    %properties (Access = private)
        window;
        screen_x_pixels;
        screen_y_pixels;
        x_center;
        y_center;
        inter_frame_interval;
        masks_number double {mustBeInteger, mustBePositive};
        masks_number_before_target double {mustBeInteger, mustBePositive};
        masks_number_while_fade_in double {mustBeInteger};
        masks;
        textures;
        target_textures;
        target_rect;
        masks_rect;
    end
        
    
    
    methods
%         function obj = CFS(waitframe, target_image_location, ...
%                            priming_image_location, cfs_mask_duration, ...
%                            left_suppression, ...
%                            target_position, target_size, target_rotation, ...
%                            target_transparency, target_appearance_delay, ...
%                            target_fade_in_duration, mask_position, ...
%                            mask_size, mask_transparency)
%             %CFS Construct an instance of this class
%             %   Detailed explanation goes here
%             if nargin > 0
%                 obj.waitframe = waitframe;
%                 obj.target_image_location = target_image_location;
%                 obj.priming_image_location = priming_image_location;
%                 obj.cfs_mask_duration = cfs_mask_duration;
%                 obj.left_suppression = left_suppression;
%                 obj.target_position = target_position;
%                 obj.target_size = target_size;
%                 obj.target_rotation = target_rotation;
%                 obj.target_transparency = target_transparency;
%                 obj.target_appearance_delay = target_appearance_delay;
%                 obj.target_fade_in_duration = target_fade_in_duration;
%                 obj.mask_position = mask_position;
%                 obj.mask_size = mask_size;
%                 obj.mask_transparency = mask_transparency;
%             end
%             
%         end
        function initiate(obj)
            [obj.screen_x_pixels, obj.screen_y_pixels, obj.x_center, ...
                obj.y_center, obj.inter_frame_interval, obj.window ...
                ] = obj.initiate_window();
            flip_secs = obj.waitframe*obj.inter_frame_interval;
            obj.masks_number = obj.cfs_mask_duration/flip_secs;
            obj.masks_number_before_target = obj.target_appearance_delay/flip_secs;
            obj.masks_number_while_fade_in = obj.target_fade_in_duration/flip_secs;
        end
        function time_elapsed = generate_mondrians(obj, shape, colors)
            %generate_mondrians(obj) Summary of this method goes here
            %   Detailed explanation goes here
            tstart = GetSecs;
            obj.masks = CFS.make_mondrian_masks(obj.screen_x_pixels/2, ...
                obj.screen_y_pixels, obj.masks_number, shape, colors);
            tend = GetSecs;
            time_elapsed = tend - tstart;
        end

        function obj = generate_textures(obj)
            %generate_textures(obj) Summary of this method goes here
            %   Detailed explanation goes here
            obj.textures = cell(1, obj.masks_number);
            for n = 1 : obj.masks_number
                obj.textures{n} = Screen('MakeTexture', obj.window, obj.masks{n});
            end
        end
        
        function obj = import_target_images(obj)
            %import_target_image(obj) Load an images from dir path and make an array of textures from it.
            %   Detailed explanation goes here
            % 
            target_images = dir(obj.target_images_path);

            % Remove '.' and '..' from a list of files
            target_images=target_images(~ismember({target_images.name},{'.','..'}));

            for img = 1:length(target_images)
                try
                    target_image = imread(fullfile(...
                        target_images(img).folder, target_images(img).name));
                    obj.target_textures{img} = Screen('MakeTexture', obj.window, target_image);
                catch
                end
            end
%             theImage = imread('./Images/Target_images/Conf_Certain.png');
%             obj.target_textures = Screen('MakeTexture', obj.window, theImage);
        end
        
        obj = get_rects(obj);
        greetings(obj, time_elapsed);
        time_elapsed = run_the_experiment(obj);
    end

    methods (Static, Access = protected)
      [screen_x_pixels,screen_y_pixels, x_center, y_center, inter_frame_interval, window] = initiate_window();
      [x0, y0, x1, y1] = get_stimulus_position(ninth, size);
      masks = make_mondrian_masks(sz_x,sz_y,n_masks,shape,selection);
    end
end

