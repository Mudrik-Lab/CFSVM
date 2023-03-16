classdef TextMAFC < CFS.Element.Evidence.ScaleEvidence
% Initiating and recording text mAFC data.
%
% Derived from :class:`~+CFS.+Element.+Evidence.@ScaleEvidence` class.
%   

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'response_time', 'response_choice', 'response_kbname', 'onset'}

    end


    properties

        text_size % Int.

    end


    methods

        function obj = TextMAFC(parameters)
        %
        % Args:
        %   keys: :attr:`.+CFS.+Element.+Evidence.@Response.Response.keys`
        %   title: :attr:`.+CFS.+Element.+Evidence.@ScaleEvidence.ScaleEvidence.title`
        %   options: :attr:`.+CFS.+Element.+Evidence.@ScaleEvidence.ScaleEvidence.options`
        %
        
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
        
        show(obj, exp);

    end

end

