classdef BreakResponse < CFS.Element.Evidence.Response
% Initiating and recording break data.
%
% Derived from :class:`~+CFS.+Element.+Evidence.@Response` class.
%
    
    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'response_time', 'response_choice', 'response_kbname'}

    end
    

    methods

        function obj = BreakResponse(parameters)

            arguments
                parameters.keys = {'LeftArrow', 'RightArrow'}
            end

            parameters_names = fieldnames(parameters);
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end
        end

        get(obj);
        create_kbqueue(obj);

    end

end

