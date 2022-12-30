classdef PAS < CFS.Element.Evidence.Evidence
% PAS Evidence class for initiating and recording PAS data.
    
    properties

        text_size
        spacing
        left_text_start
        right_text_start

    end


    properties (Constant)

        RESULTS = {'response_time', 'response_choice', 'response_kbname', 'onset'}

    end
        

    methods

        function obj = PAS(parameters)
            % PAS Construct an instance of this class

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
        show(obj, screen, frame)

    end

end

