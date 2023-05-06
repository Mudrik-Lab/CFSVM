classdef Fixation < CFSVM.Element.Stimulus.Stimulus
% Handling fixation cross.
%
% Derived from :class:`~CFSVM.Element.TemporalElement` and 
% :class:`~CFSVM.Element.SpatialElement` classes.
%

    properties (Constant)

        % Parameters to parse into the processed results table.
        RESULTS = {'onset'}

    end


    properties
        
        % Cell array storing arguments for PTB's Screen('DrawLines'). 
        args cell

    end


    methods

        function obj = Fixation(dirpath, parameters)
        %
        % Args:
        %   dirpath: :attr:`CFSVM.Element.Stimulus.Stimulus.dirpath`
        %   duration: :attr:`CFSVM.Element.TemporalElement.duration`
        %   position: :attr:`CFSVM.Element.Stimulus.Stimulus.position`
        %   xy_ratio: :attr:`CFSVM.Element.Stimulus.Stimulus.xy_ratio`
        %   size: :attr:`CFSVM.Element.Stimulus.Stimulus.size`
        %   padding: :attr:`CFSVM.Element.Stimulus.Stimulus.padding`
        %   rotation: :attr:`CFSVM.Element.Stimulus.Stimulus.rotation`
        %   contrast: :attr:`CFSVM.Element.SpatialElement.contrast`

            arguments
                dirpath {mustBeFolder}
                parameters.duration = 0
                parameters.position = "Center"
                parameters.xy_ratio = 1
                parameters.size = 0.05
                parameters.padding = 0
                parameters.rotation = 0
                parameters.contrast = 1
            end
            
            obj.dirpath = dirpath;
            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

        end
        
        preload_args(obj, screen)
        vbl = show(obj, experiment)

    end

end

