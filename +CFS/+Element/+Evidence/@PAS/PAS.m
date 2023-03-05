classdef PAS < CFS.Element.Evidence.ScaleEvidence
% Initiating and recording PAS data.
%
% Derived from :class:`~+CFS.+Element.+Evidence.@ScaleEvidence`.
%

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'response_time', 'response_choice', 'response_kbname', 'onset'}

    end


    properties

        text_size  % Int.
        spacing  % Int - round(obj.text_size/2).
        left_text_start  % Int - for the left screen.
        right_text_start  % Int - for the right screen.

    end


    methods

        function obj = PAS(parameters)
        %
        % Args:
        %   keys: :attr:`.+CFS.+Element.+Evidence.@Response.Response.keys`
        %   title: :attr:`.+CFS.+Element.+Evidence.@ScaleEvidence.ScaleEvidence.title`
        %   options: :attr:`.+CFS.+Element.+Evidence.@ScaleEvidence.ScaleEvidence.options`
        %
        
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

