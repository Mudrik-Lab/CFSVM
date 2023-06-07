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
        function obj = Mask(kwargs)
        %
        % Args:
        %   dirpath: :attr:`CFSVM.Element.Stimulus.Stimulus.dirpath`.
        %       Defaults to './Masks/'.
        %   duration: :attr:`CFSVM.Element.TemporalElement.duration`.
        %       Defaults to 0.1.
        %   soa: :attr:`~CFSVM.Element.Stimulus.Mask.soa`.
        %       Defaults to 0.2.
        %   blank: :attr:`CFSVM.Element.Stimulus.Stimulus.blank`.
        %       Defaults to 0.
        %   position: :attr:`CFSVM.Element.Stimulus.Stimulus.position`.
        %       Defaults to "Center".
        %   xy_ratio: :attr:`CFSVM.Element.Stimulus.Stimulus.xy_ratio`.
        %       Defaults to 1.
        %   size: :attr:`CFSVM.Element.Stimulus.Stimulus.size`.
        %       Defaults to 1.
        %   padding: :attr:`CFSVM.Element.Stimulus.Stimulus.padding`.
        %       Defaults to 0.
        %   rotation: :attr:`CFSVM.Element.Stimulus.Stimulus.rotation`.
        %       Defaults to 0.
        %   contrast: :attr:`CFSVM.Element.SpatialElement.contrast`.
        %       Defaults to 1.
        %

            arguments
                kwargs.dirpath = './Masks/'
                kwargs.duration = 0.1
                kwargs.soa = 0.2
                kwargs.blank = 0
                kwargs.position = "Center"
                kwargs.xy_ratio = 1
                kwargs.size = 1
                kwargs.padding = 0
                kwargs.rotation = 0
                kwargs.contrast = 1
            end

            parameters_names = fieldnames(kwargs);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = kwargs.(parameters_names{name});
            end

        end

        function load_rect_parameters(obj, screen, is_left_suppression)
        % Calculates rects depending on suppression side for the trial.
        %
        % Args:
        %   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
        %   is_left_suppression: bool
        %
            
            if length(screen.fields) > 1
                
                obj.left_rect = obj.get_rect(screen.fields{1}.rect);
                obj.right_rect =  obj.get_rect(screen.fields{2}.rect);
                
                if is_left_suppression
                    obj.rect = obj.left_rect;
                else
                    obj.rect = obj.right_rect;
                end
        
            elseif length(screen.fields) == 1
        
                obj.rect = obj.get_rect(screen.fields{1}.rect);
        
            end
            
        end
        
    end
end

