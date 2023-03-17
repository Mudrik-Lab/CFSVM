classdef Mondrians < CFS.Element.Stimulus.Stimulus
% Manipulating Mondrian masks.
%
% Derived from :class:`~+CFS.+Element.+Stimulus.@Stimulus`.
%


    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset'}

    end


    properties

        % Float in Hz, number of masks flashed per one second.
        temporal_frequency
        % Int - shape: 1 - squares, 2 - circles, 3 - diamonds.
        mondrians_shape
        % Int - color: 1 - BRGBYCMW, 2 - grayscale, 3 - all colors,
        % for 4...15 check
        % :func:`~+CFS.+Element.+Stimulus.@Mondrians.make_mondrians`.
        mondrians_color
        % Int - overall max number of masks from blocks and trials.
        n_max
        % 1D array representing masks index for every frame.
        indices
        % Cell array storing arguments for PTB's Screen('DrawTextures') for
        % masks, stimuli, fixation and checkframe.
        args
        % 1D array recording onset times of every frame.
        vbls

    end


    methods

        function obj = Mondrians(parameters)
        %
        % Args:
        %   dirpath: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.dirpath`
        %   temporal_frequency: :attr:`~.+CFS.+Element.+Stimulus.@Mondrians.Mondrians.temporal_frequency`
        %   duration: :attr:`.+CFS.+Element.@TemporalElement.TemporalElement.duration`
        %   position: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.position`
        %   xy_ratio: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.xy_ratio`
        %   size: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.size`
        %   padding: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.padding`
        %   rotation: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.rotation`
        %   contrast: :attr:`.+CFS.+Element.@SpatialElement.SpatialElement.contrast`
        %   mondrians_shape: :attr:`~.+CFS.+Element.+Stimulus.@Mondrians.Mondrians.mondrians_shape`
        %   mondrians_color: :attr:`~.+CFS.+Element.+Stimulus.@Mondrians.Mondrians.mondrians_color`
        %   blank: :attr:`.+CFS.+Element.+Stimulus.@Stimulus.Stimulus.blank`
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

