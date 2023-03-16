classdef Mask < CFS.Element.Stimulus.Stimulus
    %MASK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset'}

    end

    properties
        soa
        % [x0, y0, x1, y1] array - stimulus rect on the left screen.
        left_rect
        % [x0, y0, x1, y1] array - stimulus rect on the right screen.
        right_rect
    end
    
    methods
        function obj = Mask(parameters)
            
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

