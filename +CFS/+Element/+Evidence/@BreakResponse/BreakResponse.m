classdef BreakResponse < CFS.Element.Evidence.Evidence
% BREAKRESPONSE Evidence class for initiating and recording break data.

    
    properties (Constant)

        RESULTS = {'response_time', 'response_choice', 'response_kbname'}

    end
    

    methods

        function obj = BreakResponse(parameters)
            % BREAKRESPONSE Construct an instance of this class

            arguments
                parameters.keys
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

