classdef ImgMAFC < CFS.Element.Evidence.Evidence & CFS.Element.Stimulus.Stimulus
    %OBJECTIVEEVIDENCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        img_indices
    end
    
    properties (Constant)
        RESULTS = {'response_time', 'response_choice', 'response_kbname', 'onset', 'img_indices'}
    end

    methods
        function obj = ImgMAFC(parameters)
            %OBJECTIVEEVIDENCE Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                parameters.keys
                parameters.title
                parameters.position
                parameters.size
                parameters.xy_ratio
            end

            parameters_names = fieldnames(parameters);
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

            obj.n_options = length(obj.keys);
        end
        
        load_parameters(obj, screen, PTB_textures_indices, shown_texture_index)
        show(obj, screen, frame)
    end
end

