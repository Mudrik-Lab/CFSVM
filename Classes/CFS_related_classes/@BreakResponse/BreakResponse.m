classdef BreakResponse < Evidence
    %BREAKRESPONSE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        RESULTS = {'response_time', 'response_choice', 'response_kbname'}
    end
    
    methods
        function obj = BreakResponse(parameters)
            %BREAKRESPONSE Construct an instance of this class
            %   Detailed explanation goes here
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

