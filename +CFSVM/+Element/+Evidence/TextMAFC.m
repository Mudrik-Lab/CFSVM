classdef TextMAFC < CFSVM.Element.Evidence.ScaleEvidence
% Initiating and recording text mAFC data.
%

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'response_time', 'response_choice', 'response_kbname', 'onset'}

    end


    properties
        
        % ``Nonnegative int``
        text_size {mustBeNonnegative, mustBeInteger} 

    end


    methods

        function obj = TextMAFC(kwargs)
        %
        % Args:
        %   keys: :attr:`~CFSVM.Element.ResponseElement.keys`.
        %       Defaults to ``{'LeftArrow', 'RightArrow'}``.
        %   title: :attr:`~CFSVM.Element.Evidence.ScaleEvidence.title`.
        %       Defaults to ``'Which one have you seen?'``.
        %   options: :attr:`~CFSVM.Element.Evidence.ScaleEvidence.options`.
        %       Defaults to ``{'Option_1', 'Option_2'}``.
        %
            arguments
                kwargs.keys = {'LeftArrow', 'RightArrow'}
                kwargs.title = 'Which one have you seen?'
                kwargs.options = {'Option_1', 'Option_2'}
            end

            if length(kwargs.keys) ~= length(kwargs.options)
                error('Number of keys and options should be equal')
            end
            kwargs_names = fieldnames(kwargs);
            for name = 1:length(kwargs_names)
                obj.(kwargs_names{name}) = kwargs.(kwargs_names{name});
            end

            obj.n_options = length(obj.keys);
        end
        
        function show(obj, experiment)
        % Shows text version of mAFC, waits for the subject response and records it.
        % 
        % See also :meth:`CFSVM.Element.Evidence.ScaleEvidence.record_response`.
        %
        % Args:
        %   experiment: An experiment object.
        %
            
            screen = experiment.screen;
            PADDING = 10;
            obj.title_size = round(screen.fields{1}.x_pixels/15);
            obj.text_size = round(obj.title_size/1.5);
            left_screen_shift = screen.fields{1}.x_pixels/obj.n_options;
            right_screen_shift = screen.fields{2}.x_pixels/obj.n_options;
        
            Screen('TextSize', screen.window, obj.title_size);
            text_bounds = Screen('TextBounds', screen.window, obj.title);
            title_length = text_bounds(3)-text_bounds(1);
            Screen('DrawText', ...
                screen.window, ...
                obj.title, ...
                screen.fields{1}.x_center-title_length/2, ...
                screen.fields{1}.rect(2)+PADDING);
            Screen('DrawText', ...
                screen.window, ...
                obj.title, ...
                screen.fields{2}.x_center-title_length/2, ...
                screen.fields{2}.rect(2)+PADDING);
        
        
            Screen('TextSize', screen.window, obj.text_size);
            for index = 1:obj.n_options
                Screen('DrawText', ...
                    screen.window, ...
                    obj.options{index}, ...
                    screen.fields{1}.rect(1)+(index-(1-0.5/obj.n_options))*left_screen_shift, ...
                    screen.fields{1}.y_center-obj.text_size);
                Screen('DrawText', ...
                    screen.window, ...
                    obj.options{index}, ...
                    screen.fields{2}.rect(1)+(index-(1-0.5/obj.n_options))*right_screen_shift, ...
                    screen.fields{2}.y_center-obj.text_size);
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

