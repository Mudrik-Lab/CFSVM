classdef Fixation < CFS.Element.TemporalElement & CFS.Element.SpatialElement
% FIXATION Stimulus class for handling fixation "cross".
    
    properties
        
        % Size of the arms of the fixation cross in pixels.
        arm_length
        
        % Line width of the fixation cross in pixels.
        line_width

    end


    properties (SetAccess = protected)

        args

    end


    properties (Constant)

        RESULTS = {'onset'}

    end


    methods

        function obj = Fixation(parameters)
            % FIXATION Construct an instance of this class
            arguments
                parameters.duration
                parameters.arm_length
                parameters.line_width
                parameters.color = '#525252';
            end

            obj.duration = parameters.duration;
            obj.arm_length = parameters.arm_length;
            obj.line_width = parameters.line_width;
            
            % Convert hex code to matlab RGB code.
            obj.color = sscanf(parameters.color(2:end), '%2x%2x%2x', [1 3])/255;

        end
        
        load_args(obj, screen)
        vbl = show(obj, experiment)

    end

end

