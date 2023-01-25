classdef PAS < CFS.Element.Evidence.ScaleEvidence
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
                parameters.keys = {'0)', '1!', '2@', '3#'}
                parameters.title = 'How clear was the experience?'
                parameters.options = { ...
                    '0: No experience', ...
                    '1: A weak experience', ... 
                    '2: An almost clear experience', ...
                    '3: A clear experience'}
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

