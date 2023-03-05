classdef SuppressedStimulus < CFS.Element.Stimulus.Stimulus
% Manipulating stimulus suppressed by mondrians.
%
% Derived from :class:`~+CFS.+Element.+Stimulus.@Stimulus`.
%

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset', 'full_contrast_onset', 'fade_out_onset', 'position', 'index', 'image_name'}

    end

    
    properties
        
        % Float - seconds of Mondrians flashing before stimulus appearance
        appearance_delay 
        % Float - duration in seconds of stimulus fade in.
        fade_in_duration
        % Float - duration in seconds of stable contrast stimulus presentation.
        show_duration
        % Float - duration in seconds of stimulus fade out.
        fade_out_duration
        % [x0, y0, x1, y1] array - stimulus rect on the left screen.
        left_rect
        % [x0, y0, x1, y1] array - stimulus rect on the right screen.
        right_rect
        % 1D array representing contrast for every frame of flashing.
        contrasts
        % 1D array representing by 1 if stimulus is shown for current frame.
        indices
        % Onset time of stable contrast stimulus
        full_contrast_onset
        % Onset time of stimulus dissapearance
        fade_out_onset

        
    end


    methods

        function obj = SuppressedStimulus(dirpath, parameters)
        %
        % Args:
        %   dirpath: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.dirpath`
        %   position: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.position`
        %   xy_ratio: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.xy_ratio`
        %   size: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.size`
        %   padding: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.padding`
        %   rotation: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.rotation`
        %   contrast: :attr:`.+CFS.+Element.@SpatialElement.SpatialElement.contrast`
        %   appearance_delay: :attr:`~.+CFS.+Element.+Stimulus.@SuppressedStimulus.SuppressedStimulus.appearance_delay`
        %   fade_in_duration: :attr:`~.+CFS.+Element.+Stimulus.@SuppressedStimulus.SuppressedStimulus.fade_in_duration`
        %   show_duration: :attr:`~.+CFS.+Element.+Stimulus.@SuppressedStimulus.SuppressedStimulus.show_duration`
        %   fade_out_duration: :attr:`~.+CFS.+Element.+Stimulus.@SuppressedStimulus.SuppressedStimulus.fade_out_duration`
        %

            arguments
                dirpath {mustBeFolder}
                parameters.position = "Center"
                parameters.xy_ratio = 1
                parameters.size = 0.5
                parameters.padding = 0.5
                parameters.rotation = 0
                parameters.contrast = 1
                parameters.appearance_delay = 0
                parameters.fade_in_duration = 0
                parameters.show_duration = 1
                parameters.fade_out_duration = 0
            end
            
            obj.dirpath = dirpath;
            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

        end
        
        load_flashing_parameters(obj, screen, masks);
        load_rect_parameters(obj, screen, is_left_suppression);
        
    end
end

