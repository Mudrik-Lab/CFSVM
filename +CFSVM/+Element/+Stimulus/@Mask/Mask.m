classdef Mask < CFSVM.Element.Stimulus.Stimulus
% Manipulating Mask stimulus.
%
% Derived from :class:`~CFSVM.Element.Stimulus.Stimulus`.
%

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset'}

    end

    properties
        
        % Float - stimulus onset asynchrony between stimulus and mask.
        % For soa < 0 - forward masking, soa == 0 - simultaneous masking,
        % soa > 0 - backward masking
        soa {mustBeReal}
        % [x0, y0, x1, y1] array - stimulus rect on the left screen.
        left_rect (1,4) {mustBeInteger}
        % [x0, y0, x1, y1] array - stimulus rect on the right screen.
        right_rect (1,4) {mustBeInteger}

    end
    
    methods
        function obj = Mask(parameters)
        %
        % Args:
        %   dirpath: :attr:`CFSVM.Element.Stimulus.Stimulus.dirpath`
        %   duration: :attr:`CFSVM.Element.TemporalElement.duration`
        %   soa: :attr:`~CFSVM.Element.Stimulus.Mask.soa`
        %   blank: :attr:`CFSVM.Element.Stimulus.Stimulus.blank`
        %   position: :attr:`CFSVM.Element.Stimulus.Stimulus.position`
        %   xy_ratio: :attr:`CFSVM.Element.Stimulus.Stimulus.xy_ratio`
        %   size: :attr:`CFSVM.Element.Stimulus.Stimulus.size`
        %   padding: :attr:`CFSVM.Element.Stimulus.Stimulus.padding`
        %   rotation: :attr:`CFSVM.Element.Stimulus.Stimulus.rotation`
        %   contrast: :attr:`CFSVM.Element.SpatialElement.contrast`
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

