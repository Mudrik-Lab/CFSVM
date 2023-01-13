classdef TargetStimulus < CFS.Element.Stimulus.Stimulus
% TARGETSTIMULUS Stimulus class for manipulating target stimulus.
    
    properties
        left_rect
        right_rect
    end
    
    properties (Constant)

        RESULTS = {'onset', 'offset', 'index', 'image_name'}

    end


    methods

        function obj = TargetStimulus(dirpath, parameters)
            % TARGETSTIMULUS Construct an instance of this class

            arguments
                dirpath {mustBeFolder}
                parameters.duration = 1
                parameters.position = "Center"
                parameters.xy_ratio = 1
                parameters.size = 0.3
                parameters.padding = 0.5
                parameters.rotation = 0
                parameters.contrast = 1
            end
            
            obj.dirpath = dirpath;
            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

        end
        
        load_rect_parameters(obj, screen)
        show(obj, experiment)

    end
    
end
