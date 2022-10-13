classdef TextMAFC < Evidence
    %TEXTMAFC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        text_size
    end

    properties (Constant)
        RESULTS = {'response_time', 'response_choice', 'response_kbname', 'onset'}
    end

    methods
        function obj = TextMAFC(parameters)
            %TEXTMAFC Construct an instance of this class
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
        
        show(obj, screen);
    end
end

