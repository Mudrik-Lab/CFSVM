classdef Fixation < CFSVM.Element.TemporalElement & CFSVM.Element.SpatialElement
% Handling fixation cross.
%
% Derived from :class:`~+CFSVM.+Element.@TemporalElement` and 
% :class:`~+CFSVM.+Element.@SpatialElement` classes.
%

    properties (Constant)

        % Parameters to parse into the processed results table.
        RESULTS = {'onset'}

    end


    properties
        
        % Int - size of the arms of the fixation cross in pixels.
        arm_length {mustBeNonnegative, mustBeInteger}
        % Int - line width of the fixation cross in pixels.
        line_width {mustBeNonnegative, mustBeInteger}
        % Cell array storing arguments for PTB's Screen('DrawLines'). 
        args cell

    end


    methods

        function obj = Fixation(parameters)
        %
        % Args:
        %   duration: :attr:`.+CFSVM.+Element.@TemporalElement.TemporalElement.duration`
        %   arm_length: :attr:`~.+CFSVM.+Element.+Stimulus.@Fixation.Fixation.arm_length`
        %   line_width: :attr:`~.+CFSVM.+Element.+Stimulus.@Fixation.Fixation.line_width`
        %   color: :attr:`.+CFSVM.+Element.@SpatialElement.SpatialElement.color`
        %

            arguments
                parameters.duration = 1;
                parameters.arm_length = 20;
                parameters.line_width = 4;
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

