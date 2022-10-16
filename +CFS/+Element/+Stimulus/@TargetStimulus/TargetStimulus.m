classdef TargetStimulus < CFS.Element.Stimulus.Stimulus
    %TARGETSTIMULUS Summary of this class goes here
    %   Detailed explanation goes here
    

    properties (Constant)
        RESULTS = {'onset', 'offset', 'index'}
    end

    methods
        function obj = TargetStimulus(dirpath, parameters)
            %TARGETSTIMULUS Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                dirpath {mustBeFolder}
                parameters.duration
                parameters.position
                parameters.xy_ratio
                parameters.size
                parameters.padding
                parameters.rotation
                parameters.contrast
            end
            
            obj.dirpath = dirpath;
            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end
        end
        
        show(obj, experiment)
    end
end

