classdef PAS < CFS.Element.Evidence.Evidence
    %SUBJECTIVEEVIDENCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        text_size
    end

    properties (Access = protected)
        spacing
        left_text_start
        right_text_start
    end

    properties (Constant)
        RESULTS = {'response_time', 'response_choice', 'response_kbname', 'onset'}
    end
        
    methods
        function obj = PAS(parameters)
            %SUBJECTIVEEVIDENCE Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                parameters.keys
                parameters.title
                parameters.options
            end

            parameters_names = fieldnames(parameters);
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

            obj.n_options = length(obj.keys);
        end
        load_parameters(obj, screen)
        show(obj, screen)
    end
end

