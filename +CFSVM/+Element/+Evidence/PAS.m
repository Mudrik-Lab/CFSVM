classdef PAS < CFSVM.Element.Evidence.ScaleEvidence
% Initiating and recording PAS data.
%

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'response_time', 'response_choice', 'response_kbname', 'onset'}

    end


    properties

        % ``Nonnegative int``
        text_size {mustBeNonnegative, mustBeInteger} 
        % ``Nonnegative int`` round(text_size/2).
        spacing {mustBeNonnegative, mustBeInteger} 
        % ``Nonnegative int`` for the left screen.
        left_text_start {mustBeNonnegative, mustBeInteger} 
        % ```Nonnegative int`` for the right screen.
        right_text_start {mustBeNonnegative, mustBeInteger} 

    end


    methods

        function obj = PAS(kwargs)
        %
        % Args:
        %   keys: :attr:`~CFSVM.Element.ResponseElement.keys`.
        %       Defaults to ``{'0)', '1!', '2@', '3#'}``.
        %   title: :attr:`~CFSVM.Element.Evidence.ScaleEvidence.title`.
        %       Defaults to ``'How clear was the experience?'``.
        %   options: :attr:`~CFSVM.Element.Evidence.ScaleEvidence.options`
        %       Defaults to::
        %       
        %           {'0: No experience', ...
        %            '1: A weak experience', ... 
        %            '2: An almost clear experience', ...
        %            '3: A clear experience'}
        %
        
            arguments
                kwargs.keys = {'0)', '1!', '2@', '3#'}
                kwargs.title = 'How clear was the experience?'
                kwargs.options = { ...
                    '0: No experience', ...
                    '1: A weak experience', ... 
                    '2: An almost clear experience', ...
                    '3: A clear experience'}
            end

            kwargs_names = fieldnames(kwargs);
            for name = 1:length(kwargs_names)
                obj.(kwargs_names{name}) = kwargs.(kwargs_names{name});
            end

            obj.n_options = length(obj.keys);
        end

        function load_parameters(obj, screen)
        % Loads PAS parameters for the trial.
        %
        % Args:
        %   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
        %
        
            obj.title_size = round(screen.fields{1}.x_pixels/15);
            obj.text_size = round(obj.title_size/1.5);
            obj.spacing = round(obj.text_size/2);
            if length(screen.fields) > 1
                obj.left_text_start = round(screen.fields{1}.y_center-(obj.text_size+obj.spacing)*obj.n_options/2);
                obj.right_text_start = round(screen.fields{2}.y_center-(obj.text_size+obj.spacing)*obj.n_options/2);
            else
                obj.left_text_start = round(screen.fields{1}.y_center-(obj.text_size+obj.spacing)*obj.n_options/2);
            end
            
        end

        function show(obj, experiment)
        % Shows PAS screen, waits for the subject response and records it.
        % 
        % See also :func:`~CFSVM.Element.Evidence.record_response`.
        %
        % Args:
        %   experiment: An experiment object.
        %
        
            screen = experiment.screen;
            PADDING = 10;
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
        
            Screen('TextSize', screen.window, obj.text_size);
            for index = 1:obj.n_options
                Screen('DrawText', ...
                    screen.window, ... 
                    obj.options{index}, ...
                    screen.fields{1}.rect(1)+PADDING, ...
                    obj.left_text_start+(obj.text_size+obj.spacing)*(index-1));
                
                if length(screen.fields) > 1
                    Screen('DrawText', ...
                        screen.window, ... 
                        obj.options{index}, ...
                        screen.fields{2}.rect(1)+PADDING, ...
                        obj.right_text_start+(obj.text_size+obj.spacing)*(index-1));
                end
            end
            
            if isa(experiment, "CFSVM.Experiment.CFS")
                % Checkerboard frame
                Screen('FillRect', screen.window, experiment.frame.colors, experiment.frame.rects);
            end
            obj.onset = Screen('Flip', screen.window);
            
            % Wait for the response.
            obj.record_response()
            obj.response_choice = obj.response_choice - 1;
          
        end

    end

end

