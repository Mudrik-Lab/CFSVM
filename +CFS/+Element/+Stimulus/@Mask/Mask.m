classdef Mask < CFS.Element.Stimulus.Stimulus
    %MASK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset'}

    end

    properties
        soa
        blank
    end
    
    methods
        function obj = Mask(parameters)
            
            arguments
                parameters.dirpath = './Masks/'
                parameters.duration = 0.1
                parameters.blank = 0.5
                parameters.soa = 0.2
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
        
    end
end

