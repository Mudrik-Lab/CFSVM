classdef SuppressedStimulus < CFS.Element.Stimulus.Stimulus
% SUPPRESSEDSTIMULUS Stimulus class for manipulating stimulus suppressed by mondrians.
    
    properties

        appearance_delay
        fade_in_duration
        show_duration
        fade_out_duration
        left_rect
        right_rect
        contrasts_in
        contrasts_out
        full_contrast_onset
        fade_out_onset

    end
    

    properties (Constant)

        RESULTS = {'onset', 'offset', 'full_contrast_onset', 'fade_out_onset', 'index', 'position'}

    end
    

    methods

        function obj = SuppressedStimulus(dirpath, parameters)
            % SUPPRESSEDSTIMULUS Construct an instance of this class

            arguments
                dirpath {mustBeFolder}
                parameters.position
                parameters.xy_ratio
                parameters.size
                parameters.padding
                parameters.rotation
                parameters.contrast
                parameters.appearance_delay
                parameters.fade_in_duration
                parameters.show_duration
                parameters.fade_out_duration
            end
            
            obj.dirpath = dirpath;
            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

        end
        
        load_flashing_parameters(obj, masks);
        load_rect_parameters(obj, screen, is_left_suppression);
        
    end
end

