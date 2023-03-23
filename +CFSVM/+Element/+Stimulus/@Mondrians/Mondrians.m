classdef Mondrians < CFSVM.Element.Stimulus.Stimulus
% Manipulating Mondrian masks.
%
% Derived from :class:`~+CFSVM.+Element.+Stimulus.@Stimulus`.
%


    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset'}

    end


    properties

        % Float in Hz, number of masks flashed per one second.
        temporal_frequency {mustBeNonnegative}
        % Int - shape: 1 - squares, 2 - circles, 3 - diamonds.
        mondrians_shape {mustBeInRange(mondrians_shape, 1, 3), mustBeInteger}
        % Int - color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
        % for 4...15 check
        % :func:`~+CFSVM.+Element.+Stimulus.@Mondrians.make_mondrians`.
        mondrians_color {mustBeInRange(mondrians_color, 1, 15), mustBeInteger}
        % Int - overall max number of masks from blocks and trials.
        n_max {mustBeNonnegative, mustBeInteger}
        % 1D array representing masks index for every frame.
        indices {mustBeInteger}
        % Cell array storing arguments for PTB's Screen('DrawTextures') for
        % masks, stimuli, fixation and checkframe.
        args cell
        % 1D array recording onset times of every frame.
        vbls {mustBeNonnegative}

    end


    methods

        function obj = Mondrians(parameters)
        %
        % Args:
        %   dirpath: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.dirpath`
        %   temporal_frequency: :attr:`~.+CFSVM.+Element.+Stimulus.@Mondrians.Mondrians.temporal_frequency`
        %   duration: :attr:`.+CFSVM.+Element.@TemporalElement.TemporalElement.duration`
        %   position: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.position`
        %   xy_ratio: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.xy_ratio`
        %   size: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.size`
        %   padding: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.padding`
        %   rotation: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.rotation`
        %   contrast: :attr:`.+CFSVM.+Element.@SpatialElement.SpatialElement.contrast`
        %   mondrians_shape: :attr:`~.+CFSVM.+Element.+Stimulus.@Mondrians.Mondrians.mondrians_shape`
        %   mondrians_color: :attr:`~.+CFSVM.+Element.+Stimulus.@Mondrians.Mondrians.mondrians_color`
        %   blank: :attr:`.+CFSVM.+Element.+Stimulus.@Stimulus.Stimulus.blank`
        %

            arguments
                parameters.dirpath = './Masks/'
                parameters.temporal_frequency = 10
                parameters.duration = 5
                parameters.position = "Center"
                parameters.xy_ratio = 1
                parameters.size = 1
                parameters.padding = 0
                parameters.rotation = 0
                parameters.contrast = 1
                parameters.mondrians_shape = 1
                parameters.mondrians_color = 1
                parameters.blank = 0
            end

            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

        end
        
        get_max(obj, trial_matrices)
        shuffle(obj)
        make_mondrians(obj, x_pixels, y_pixels)
        load_rect_parameters(obj, screen, is_left_suppression)
        load_flashing_parameters(obj, screen)

    end

end

