classdef SuppressedStimulus < CFSVM.Element.Stimulus.Stimulus
% Manipulating stimulus suppressed by mondrians.
%
% Derived from :class:`~+CFSVM.+Element.+Stimulus.@Stimulus`.
%

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset', 'full_contrast_onset', 'fade_out_onset', 'position', 'index', 'image_name'}

    end

    
    properties
        
        % Float - seconds of Mondrians flashing before stimulus appearance
        appearance_delay {mustBeNonnegative}
        % Float - duration in seconds of stimulus fade in.
        fade_in_duration {mustBeNonnegative}
        % Float - duration in seconds of stimulus fade out.
        fade_out_duration {mustBeNonnegative}
        % [x0, y0, x1, y1] array - stimulus rect on the left screen.
        left_rect (1,4) {mustBeInteger}
        % [x0, y0, x1, y1] array - stimulus rect on the right screen.
        right_rect (1,4) {mustBeInteger}
        % 1D array representing contrast for every frame of flashing.
        contrasts {mustBeInRange(contrasts,0,1)}
        % 1D array representing shown for current frame stimulus when set to 1.
        indices {mustBeInteger, mustBeInRange(indices,0,1)}
        % Onset time of stable contrast stimulus
        full_contrast_onset {mustBeNonnegative}
        % Onset time of stimulus dissapearance
        fade_out_onset {mustBeNonnegative}

        
    end


    methods

        function obj = SuppressedStimulus(dirpath, parameters)
        %
        % Args:
        %   dirpath: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.dirpath`
        %   position: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.position`
        %   xy_ratio: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.xy_ratio`
        %   size: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.size`
        %   padding: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.padding`
        %   rotation: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.rotation`
        %   contrast: :attr:`.+CFSVM.+Element.@SpatialElement.SpatialElement.contrast`
        %   appearance_delay: :attr:`~.+CFSVM.+Element.+Stimulus.@SuppressedStimulus.SuppressedStimulus.appearance_delay`
        %   fade_in_duration: :attr:`~.+CFSVM.+Element.+Stimulus.@SuppressedStimulus.SuppressedStimulus.fade_in_duration`
        %   duration: :attr:`.+CFSVM.+Element.@TemporalElement.TemporalElement.duration`
        %   fade_out_duration: :attr:`~.+CFSVM.+Element.+Stimulus.@SuppressedStimulus.SuppressedStimulus.fade_out_duration`
        %   blank: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.blank`
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
                parameters.duration = 1
                parameters.fade_out_duration = 0
                parameters.blank = 0
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

