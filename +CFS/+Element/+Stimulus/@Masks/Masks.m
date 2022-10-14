classdef Masks < CFS.Element.Stimulus.Stimulus
    %MASKS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Number of masks flashed per one second.
        temporal_frequency = 10
        
        % Duration of suppressing pattern in seconds.
        duration = 5
        
        % Shape: 1 - squares, 2 - circles, 3 - diamonds.
        mondrians_shape = 1
        
        % Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
        % for 4...15 see 'help CFS.generate_mondrians'.
        mondrians_color = 15
        

        n {mustBeInteger, mustBePositive};
        n_before_stimulus {mustBeInteger}
        n_while_fade_in {mustBeInteger}
        n_while_stimulus {mustBeInteger}
        n_while_fade_out {mustBeInteger}
        n_cumul_before_fade_out {mustBeInteger}
        n_max

        waitframe
        delay

        indices_while_fade_in
        indices_while_fade_out
        rect

        seed;
    end

    properties (Constant)
        RESULTS = {'onset', 'offset', 'seed'}
    end
    
    methods
        function obj = Masks(dirpath, parameters)
            %MASKS Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                dirpath
                parameters.temporal_frequency
                parameters.duration
                parameters.mondrians_shape
                parameters.mondrians_color
                parameters.position
                parameters.xy_ratio
                parameters.size
                parameters.padding
                parameters.rotation
                parameters.contrast
            end

            obj.dirpath = dirpath;
            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end
        end
        
        function initiate(obj, trial_matrices)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            max_temporal_frequency = max(cellfun(@(matrix) (max(matrix.('masks.temporal_frequency'))), trial_matrices));
            max_mask_duration = max(cellfun(@(matrix) (max(matrix.('masks.duration'))), trial_matrices));
            obj.n_max = max_temporal_frequency*max_mask_duration+1;
        end

        shuffle(obj, seed);
        make_mondrian_masks(obj, x_pixels, y_pixels);
        load_rect_parameters(obj, screen, is_left_suppression);
        load_flashing_parameters(obj, screen);

    end
end

