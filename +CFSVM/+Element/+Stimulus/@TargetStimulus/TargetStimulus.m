classdef TargetStimulus < CFSVM.Element.Stimulus.Stimulus
% Manipulating target stimulus.
%
% Derived from :class:`~+CFSVM.+Element.+Stimulus.@Stimulus`.
%


    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset', 'index', 'image_name'}

    end


    properties

        % [x0, y0, x1, y1] array - stimulus rect on the left screen.
        left_rect
        % [x0, y0, x1, y1] array - stimulus rect on the right screen.
        right_rect

    end
    



    methods

        function obj = TargetStimulus(dirpath, parameters)
        %
        % Args:
        %   dirpath: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.dirpath`
        %   duration: :attr:`.+CFSVM.+Element.@TemporalElement.TemporalElement.duration`
        %   position: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.position`
        %   xy_ratio: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.xy_ratio`
        %   size: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.size`
        %   padding: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.padding`
        %   rotation: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.rotation`
        %   contrast: :attr:`.+CFSVM.+Element.@SpatialElement.SpatialElement.contrast`
        %
        
            arguments
                dirpath {mustBeFolder}
                parameters.duration = 1
                parameters.position = "Center"
                parameters.xy_ratio = 1
                parameters.size = 0.3
                parameters.padding = 0.5
                parameters.rotation = 0
                parameters.contrast = 1
            end
            
            obj.dirpath = dirpath;
            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

        end
        
        load_rect_parameters(obj, screen)
        show(obj, experiment)

    end
    
end
