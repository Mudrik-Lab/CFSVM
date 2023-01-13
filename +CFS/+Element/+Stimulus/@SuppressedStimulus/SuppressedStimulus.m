classdef SuppressedStimulus < CFS.Element.Stimulus.Stimulus
% SUPPRESSEDSTIMULUS Stimulus class for manipulating stimulus suppressed by mondrians.
    
    properties

        appearance_delay
        fade_in_duration
        show_duration
        fade_out_duration
        left_rect
        right_rect
        contrasts
        full_contrast_onset
        fade_out_onset
        indices
        
    end
    

    properties (Constant)

        RESULTS = {'onset', 'offset', 'full_contrast_onset', 'fade_out_onset', 'position', 'index', 'image_name'}

    end
    

    methods

        function obj = SuppressedStimulus(dirpath, parameters)
            % SUPPRESSEDSTIMULUS Construct an instance of this class

            arguments
                dirpath {mustBeFolder}
                parameters.position = "Center"
                parameters.xy_ratio = 1
                parameters.size = 0.5
                parameters.padding = 0.5
                parameters.rotation = 0
                parameters.contrast = 1
                parameters.appearance_delay = 0
                parameters.fade_in_duration = 0
                parameters.show_duration = 1
                parameters.fade_out_duration = 0
            end
            
            obj.dirpath = dirpath;
            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

        end
        
        load_flashing_parameters(obj, screen, masks);
        load_rect_parameters(obj, screen, is_left_suppression);
        
    end
end

