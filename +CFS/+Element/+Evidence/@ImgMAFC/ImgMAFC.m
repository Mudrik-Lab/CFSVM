classdef ImgMAFC < CFS.Element.Evidence.ScaleEvidence & CFS.Element.Stimulus.Stimulus
% Initiating and recording image mAFC data.
%
% Derived from :class:`~+CFS.+Element.+Evidence.@ScaleEvidence` and
% :class:`~+CFS.+Element.+Stimulus.@Stimulus` classes.
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
        show(obj, screen, frame)

    end

end