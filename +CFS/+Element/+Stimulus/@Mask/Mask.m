classdef Mask < CFS.Element.Stimulus.Stimulus
% Manipulating Mask stimulus.
%
% Derived from :class:`~+CFS.+Element.+Stimulus.@Stimulus`.
%

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset'}

    end

    properties
        
        % Float - stimulus onset asynchrony between stimulus and mask.
        % For soa < 0 - forward masking, soa == 0 - simultaneous masking,
        % soa > 0 - backward masking
        soa
        % [x0, y0, x1, y1] array - stimulus rect on the left screen.
        left_rect
        % [x0, y0, x1, y1] array - stimulus rect on the right screen.
        right_rect

    end
    
    methods
        function obj = Mask(parameters)
        %
        % Args:
        %   dirpath: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.dirpath`
        %   duration: :attr:`.+CFS.+Element.@TemporalElement.TemporalElement.duration`
        %   soa: :attr:`~.+CFS.+Element.+Stimulus.@Mask.Mask.soa`
        %   blank: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.blank`
        %   position: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.position`
        %   xy_ratio: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.xy_ratio`
        %   size: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.size`
        %   padding: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.padding`
        %   rotation: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.rotation`
        %   contrast: :attr:`.+CFS.+Element.@SpatialElement.SpatialElement.contrast`
        %

            arguments
                parameters.dirpath = './Masks/'
                parameters.duration = 0.1
                parameters.soa = 0.2
                parameters.blank = 0
                parameters.position = "Center"
                parameters.xy_ratio = 1
                parameters.size = 1
                parameters.padding = 0
                parameters.rotation = 0
                parameters.contrast = 1
            end

            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

        end

        load_rect_parameters(obj, screen, is_left_suppression)
        
    end
end

