classdef ImgMAFC < CFSVM.Element.Evidence.ScaleEvidence & CFSVM.Element.Stimulus.Stimulus
% Initiating and recording image mAFC data.
%
% Derived from :class:`~+CFSVM.+Element.+Evidence.@ScaleEvidence` and
% :class:`~+CFSVM.+Element.+Stimulus.@Stimulus` classes.
%
 

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'response_time', 'response_choice', 'response_kbname', 'onset', 'img_indices'}

    end


    properties

        img_indices  % Char array with images indices separated by spaces.

    end


    methods

        function obj = ImgMAFC(parameters)
        %
        % Args:
        %   keys: :attr:`.+CFSVM.+Element.+Evidence.@Response.Response.keys`
        %   title: :attr:`.+CFSVM.+Element.+Evidence.@ScaleEvidence.ScaleEvidence.title`
        %   position: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.position`
        %   size: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.size`
        %   xy_ratio: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.xy_ratio`
        %

            arguments
                parameters.keys = {'LeftArrow', 'RightArrow'}
                parameters.title = 'Which one have you seen?'
                parameters.position = 'Center'
                parameters.size = 0.75
                parameters.xy_ratio = 1
            end

            parameters_names = fieldnames(parameters);
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

            obj.n_options = length(obj.keys);
        end
        
        load_parameters(obj, screen, PTB_textures_indices, shown_texture_index)
        show(obj, experiment)

    end

end