classdef Masks < CFS.Element.Stimulus.Stimulus
% MASKS Stimulus class for manipulating mondrian masks.
    
    properties

        % Number of masks flashed per one second.
        temporal_frequency
        
        % Shape: 1 - squares, 2 - circles, 3 - diamonds.
        mondrians_shape
        
        % Color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
        % for 4...15 see 'help CFS.generate_mondrians'.
        mondrians_color

        n_max
        
        indices

        args

        vbls

    end


    properties (Constant)

        RESULTS = {'onset', 'offset'}

    end
    

    methods

        function obj = Masks(dirpath, parameters)
            % MASKS Construct an instance of this class

            arguments
                dirpath {mustBeFolder}
                parameters.temporal_frequency = 10
                parameters.duration = 5
                parameters.mondrians_shape = 1
                parameters.mondrians_color = 15
                parameters.position = "Center"
                parameters.xy_ratio = 1
                parameters.size = 1
                parameters.padding = 0
                parameters.rotation = 0
                parameters.contrast = 1
            end

            obj.dirpath = dirpath;
            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

        end
        
        initiate(obj, trial_matrices)
        shuffle(obj)
        make_mondrian_masks(obj, x_pixels, y_pixels)
        load_rect_parameters(obj, screen, is_left_suppression)
        load_flashing_parameters(obj, screen)

    end

end

