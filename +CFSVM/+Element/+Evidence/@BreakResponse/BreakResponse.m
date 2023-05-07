classdef BreakResponse < CFSVM.Element.ResponseElement
% Initiating and recording break data.
%
% Derived from :class:`~CFSVM.Element.ResponseElement` class.
%
    
    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'response_time', 'response_choice', 'response_kbname'}

    end
    

    methods

        function obj = BreakResponse(parameters)
        %
        % Args:
        %   keys: :attr:`CFSVM.Element.ResponseElement.keys`
        %
        
            arguments
                parameters.keys = {'LeftArrow', 'RightArrow'}
            end

            parameters_names = fieldnames(parameters);
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end
        end

        get(obj, pressed, first_press);
        create_kbqueue(obj);

    end

end

