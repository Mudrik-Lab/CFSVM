classdef SuppressedStimulus < CFSVM.Element.Stimulus.Stimulus
    % Manipulating stimulus suppressed by mondrians.
    %
    % Derived from :class:`~CFSVM.Element.Stimulus.Stimulus`.
    %

    properties (Constant)

        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset', 'full_contrast_onset', 'fade_out_onset', 'position', 'index', 'image_name'}

    end

    properties

        % Float - seconds of Mondrians flashing before stimulus appearance
        appearance_delay {mustBeNonnegative}
        % Float - duration in seconds of stimulus fade in.
        fade_in_duration {mustBeNonnegative}
        % Float - duration in seconds of stimulus fade out.
        fade_out_duration {mustBeNonnegative}
        % [x0, y0, x1, y1] array - stimulus rect on the left screen.
        left_rect (1, 4) {mustBeInteger}
        % [x0, y0, x1, y1] array - stimulus rect on the right screen.
        right_rect (1, 4) {mustBeInteger}
        % 1D array representing contrast for every frame of flashing.
        contrasts {mustBeInRange(contrasts, 0, 1)}
        % 1D array representing shown for current frame stimulus when set to 1.
        indices {mustBeInteger, mustBeInRange(indices, 0, 1)}
        % Onset time of stable contrast stimulus
        full_contrast_onset {mustBeNonnegative}
        % Onset time of stimulus dissapearance
        fade_out_onset {mustBeNonnegative}

    end

    methods

        function obj = SuppressedStimulus(dirpath, kwargs)
            %
            % Args:
            %   dirpath: :attr:`CFSVM.Element.Stimulus.Stimulus.dirpath`.
            %   position: :attr:`CFSVM.Element.Stimulus.Stimulus.position`.
            %       Defaults to "Center".
            %   xy_ratio: :attr:`CFSVM.Element.Stimulus.Stimulus.xy_ratio`.
            %       Defaults to 1.
            %   size: :attr:`CFSVM.Element.Stimulus.Stimulus.size`.
            %       Defaults to 0.5.
            %   padding: :attr:`CFSVM.Element.Stimulus.Stimulus.padding`.
            %       Defaults to 0.5.
            %   rotation: :attr:`CFSVM.Element.Stimulus.Stimulus.rotation`.
            %       Defaults to 0.
            %   contrast: :attr:`CFSVM.Element.SpatialElement.contrast`.
            %       Defaults to 1.
            %   appearance_delay:
            %       :attr:`~CFSVM.Element.Stimulus.SuppressedStimulus.appearance_delay`.
            %       Defaults to 0.
            %   fade_in_duration:
            %       :attr:`~CFSVM.Element.Stimulus.SuppressedStimulus.fade_in_duration`.
            %       Defaults to 0.
            %   duration: :attr:`CFSVM.Element.TemporalElement.duration`.
            %       Defaults to 1.
            %   fade_out_duration:
            %       :attr:`~CFSVM.Element.Stimulus.SuppressedStimulus.fade_out_duration`.
            %       Defaults to 0.
            %   blank: :attr:`CFSVM.Element.Stimulus.Stimulus.blank`.
            %       Defaults to 0.
            %   manual_rect:
            %       :attr:`~CFSVM.Element.Stimulus.Stimulus.manual_rect`.
            %
            arguments
                dirpath {mustBeFolder}
                kwargs.position = "Center"
                kwargs.xy_ratio = 1
                kwargs.size = 0.5
                kwargs.padding = 0.5
                kwargs.rotation = 0
                kwargs.contrast = 1
                kwargs.appearance_delay = 0
                kwargs.fade_in_duration = 0
                kwargs.duration = 1
                kwargs.fade_out_duration = 0
                kwargs.blank = 0
                kwargs.manual_rect
            end

            obj.dirpath = dirpath;
            parameters_names = fieldnames(kwargs);

            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = kwargs.(parameters_names{name});
            end

        end

        function load_flashing_parameters(obj, screen, masks)
            % Calculates contrasts arrays for flashing.
            %
            % Args:
            %   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
            %   masks: :class:`~CFSVM.Element.Stimulus.Mondrians` object.
            %

            obj.image_name = obj.textures.images_names(obj.index);

            % Calculate indiced for appearance
            cumul = [ ...
                     false(1, obj.appearance_delay * screen.frame_rate), ...
                     true(1, obj.fade_in_duration * screen.frame_rate), ...
                     true(1, obj.duration * screen.frame_rate), ...
                     true(1, obj.fade_out_duration * screen.frame_rate)];
            obj.indices = [cumul, false(1, masks.duration * screen.frame_rate - length(cumul))];

            % Calculate indices for contrasts
            if obj.contrast ~= 0
                cumul = [ ...
                         zeros(1, obj.appearance_delay * screen.frame_rate), ...
                         obj.contrast / (obj.fade_in_duration * screen.frame_rate): ...
                         obj.contrast / (obj.fade_in_duration * screen.frame_rate): ...
                         obj.contrast, ...
                         obj.contrast + zeros(1, obj.duration * screen.frame_rate), ...
                         obj.contrast: ...
                         -obj.contrast / (obj.fade_out_duration * screen.frame_rate + 1): ...
                         obj.contrast / (obj.fade_out_duration * screen.frame_rate + 1)];
            else
                cumul = [ ...
                         zeros(1, obj.appearance_delay * screen.frame_rate), ...
                         zeros(1, obj.fade_in_duration * screen.frame_rate), ...
                         zeros(1, obj.duration * screen.frame_rate), ...
                         zeros(1, obj.fade_out_duration * screen.frame_rate + 1)];
            end
            obj.contrasts = [cumul, zeros(1, masks.duration * screen.frame_rate - length(cumul))];

        end

        function load_rect_parameters(obj, screen, is_left_suppression)
            % Calculates rects depending on suppression side for the trial.
            %
            % Args:
            %   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
            %   is_left_suppression: bool
            %

            if length(screen.fields) > 1
                if ~isempty(obj.manual_rect)
                    obj.left_rect = obj.get_manual_rect(screen.fields{1}.rect);
                    obj.right_rect =  obj.get_manual_rect(screen.fields{2}.rect);
                else
                    obj.left_rect = obj.get_rect(screen.fields{1}.rect);
                    obj.right_rect =  obj.get_rect(screen.fields{2}.rect);
                end

                if is_left_suppression
                    obj.rect = obj.right_rect;
                else
                    obj.rect = obj.left_rect;
                end

            elseif length(screen.fields) == 1
                if ~isempty(obj.manual_rect)
                    obj.rect = obj.get_manual_rect(screen.fields{1}.rect);
                else
                    obj.rect = obj.get_rect(screen.fields{1}.rect);
                end

            end

        end

    end
end
