classdef ImgMAFC < CFSVM.Element.Evidence.ScaleEvidence & CFSVM.Element.Stimulus.Stimulus
% Initiating and recording image mAFC data.
%

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'response_time', 'response_choice', 'response_kbname', 'onset', 'img_indices'}

    end


    properties

        % ``Char array`` with images indices separated by spaces.
        img_indices

        % ``Cell array`` of two arrays with size ``{[n_options,4];
        % [n_options,4]}``.
        rects cell

    end


    methods

        function obj = ImgMAFC(kwargs)
        %
        % Args:
        %   keys: :attr:`~CFSVM.Element.ResponseElement.keys`. 
        %       Defaults to ``{'LeftArrow', 'RightArrow'}``.
        %   title: :attr:`~CFSVM.Element.Evidence.ScaleEvidence.title`.
        %       Defaults to ``'Which one have you seen?'``.
        %   position: :attr:`~CFSVM.Element.Stimulus.Stimulus.position`
        %       Defaults to ``'Center'``.
        %   size: :attr:`~CFSVM.Element.Stimulus.Stimulus.size`
        %       Defaults to ``0.75``.
        %   xy_ratio: :attr:`~CFSVM.Element.Stimulus.Stimulus.xy_ratio`
        %       Defaults to ``1``.
        %   rotation: :attr:`CFSVM.Element.Stimulus.Stimulus.rotation`.
        %       Defaults to ``0``.
        %   contrast: :attr:`CFSVM.Element.SpatialElement.contrast`.
        %       Defaults to ``1``.

            arguments
                kwargs.keys = {'LeftArrow', 'RightArrow'}
                kwargs.title = 'Which one have you seen?'
                kwargs.position = 'Center'
                kwargs.size = 0.75
                kwargs.xy_ratio = 1
                kwargs.rotation = 0
                kwargs.contrast = 1
            end
            
            kwargs_names = fieldnames(kwargs);
            for name = 1:length(kwargs_names)
                obj.(kwargs_names{name}) = kwargs.(kwargs_names{name});
            end
            obj.n_options = length(obj.keys);


        end
        
        function load_parameters(obj, screen, PTB_textures_indices, shown_texture_index)
        % Loads parameters for mAFC screen for the trial.
        %
        % Args:
        %   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
        %   PTB_textures_indices: ``Cell array`` of ints representing loaded PTB textures.
        %   shown_texture_index: ``Int`` representing PTB texture shown as a stimulus.
        %
        
            img_textures = PTB_textures_indices;
            obj.options = {};
        
            % Calculate shift for every mAFC choice.
            left_screen_shift = screen.fields{1}.x_pixels/obj.n_options;
        
            if length(screen.fields) > 1
                right_screen_shift = screen.fields{2}.x_pixels/obj.n_options;
            end
        
            if shown_texture_index ~= 0
                % Copy prime image used in the trial.
                obj.options{1} = img_textures{shown_texture_index};
                % Remove used prime image.
                img_textures(shown_texture_index) = [];
            end
        
            % Choose randomly n-1 not used prime images.
            obj.options = horzcat(obj.options, img_textures{randperm(length(img_textures), obj.n_options-1)});
        
            % Shuffle used prime image with not used ones.
            obj.options = obj.options(randperm(length(obj.options)));
        
            obj.img_indices = num2str(cellfun(@(x) find([PTB_textures_indices{:}]==x), obj.options));
            obj.rects = {zeros(obj.n_options,4);zeros(obj.n_options,4)};
        
            for i = 1:obj.n_options
                left = [screen.fields{1}.rect(1)+left_screen_shift*(i-1), ...
                    screen.fields{1}.rect(2), ...
                    screen.fields{1}.rect(1)+left_screen_shift*(i), ...
                    screen.fields{1}.rect(4)];
        
                obj.rects{1}(i,:) = obj.get_rect(left);
        
                if length(screen.fields) > 1
                    right = [screen.fields{2}.rect(1)+right_screen_shift*(i-1), ...
                        screen.fields{2}.rect(2), ...
                        screen.fields{2}.rect(1)+right_screen_shift*(i), ...
                        screen.fields{2}.rect(4)];
                    
                    obj.rects{2}(i,:) = obj.get_rect(right);
                end
                
            end
        
        end

        function show(obj, experiment)
        % Draws and shows mAFC images, waits for the subject response and records it.
        % 
        % See also :func:`~CFSVM.Element.Evidence.record_response`.
        %
        % Args:
        %   experiment: An experiment object.
        %
        
            screen = experiment.screen;
            PADDING=10;
            obj.title_size = round(screen.fields{1}.x_pixels/15);
            Screen('TextSize', screen.window, obj.title_size);
            text_bounds = Screen('TextBounds', screen.window, obj.title);
            title_length = text_bounds(3)-text_bounds(1);
            Screen('DrawText', ...
                screen.window, ...
                obj.title, ...
                screen.fields{1}.x_center-title_length/2, ...
                screen.fields{1}.rect(2)+PADDING);
            if length(screen.fields) > 1
                Screen('DrawText', ...
                    screen.window, ...
                    obj.title, ...
                    screen.fields{2}.x_center-title_length/2, ...
                    screen.fields{2}.rect(2)+PADDING);
            end
            
            for i = 1:obj.n_options
                Screen( ...
                    'DrawTexture', ...
                    screen.window, ...
                    obj.options{i}, ...
                    [], ...
                    obj.rects{1}(i,:), ...
                    obj.rotation, ...
                    [], ...
                    obj.contrast);

                if length(screen.fields) > 1
                    Screen( ...
                        'DrawTexture', ...
                        screen.window, ...
                        obj.options{i}, ...
                        [], ...
                        obj.rects{2}(i,:), ...
                        obj.rotation, ...
                        [], ...
                        obj.contrast);
                end
            end
        
            if isa(experiment, "CFSVM.Experiment.CFS")
                % Checkerboard frame
                Screen('FillRect', screen.window, experiment.frame.colors, experiment.frame.rects);
            end
            obj.onset = Screen('Flip', screen.window);
            
            % Wait for the response.
            obj.record_response();
            
        end

    end

end