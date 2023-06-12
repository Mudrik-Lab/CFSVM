classdef CustomScreen < matlab.mixin.Copyable
    % Storing and manipulating left and right screen areas.

    properties

        % Cell array of :class:`~CFSVM.Element.Screen.ScreenField` objects.
        fields cell
        % Int for number of pixels shifted on keypress while adjusting screens.
        shift {mustBePositive, mustBeInteger}
        % Char array of 7 chars containing HEX color.
        background_color
        % PTB window object.
        window
        % Float for empirical time between two frames,
        % approximately equals to 1/frame_rate.
        inter_frame_interval {mustBeNumeric}
        % Float for display refresh rate.
        frame_rate {mustBeNumeric}
        % Screen resolution tuple
        size

    end

    methods

        function obj = CustomScreen(kwargs)
            %
            % Args:
            %   background_color: :attr:`~CFSVM.Element.Screen.CustomScreen.background_color`.
            %   is_stereo: bool for setting two screenfields. Defaults to false.
            %   initial_rect: [x0, y0, x1, y1] array with pixel positions,
            %       if is_stereo, position of the left field. Defaults to [0,0,950, 1080].
            %   shift: :attr:`~CFSVM.Element.Screen.CustomScreen.shift`.
            %       Defaults to 10.
            %

            arguments
                kwargs.background_color {mustBeHex}
                kwargs.is_stereo {mustBeNumericOrLogical} = false
                kwargs.initial_rect (1, 4) {mustBeInteger} = [0, 0, 950, 1080]
                kwargs.shift {mustBePositive, mustBeInteger} = 10
            end

            obj.background_color = kwargs.background_color;
            obj.fields{1} = CFSVM.Element.Screen.ScreenField(kwargs.initial_rect);
            if kwargs.is_stereo
                set(0, 'units', 'pixels');
                screen_size = get(0, 'ScreenSize');
                second_rect = [ ...
                               screen_size(3) - kwargs.initial_rect(3), ...
                               kwargs.initial_rect(2), ...
                               screen_size(3) - kwargs.initial_rect(1), ...
                               kwargs.initial_rect(4)];
                obj.fields{2} = CFSVM.Element.Screen.ScreenField(second_rect);
            end
            obj.shift = kwargs.shift;

        end

        function adjust(obj, frame)
            % Creates interface for adjusting screens to the stereoscope view.
            %
            % Creates solid frame[s], that can be moved, resized or shifted relative
            % to each other by keyboard keys.
            %
            % Args:
            %   frame: :class:`~+CFSVM.+Element.+Screen.@CheckFrame` object.
            %

            MEBoundary = MException('Screen:BoundaryError', 'BoundaryError');
            MESize = MException('Frame:SizeError', 'SizeError');
            MEEsc = MException('Key:Esc_has_been_pressed', ...
                               'Esc has been pressed, the program has been terminated.');
            % Color to use when adjusting the frames.
            FRAME_COLOR = {'#4A4A4A'};
            TEXT = {'Arrows for changing position of both screens,', ...
                    'w,a,s,d for adjusting height and width,'};

            % Array of used keyboard keys
            k = {'LeftArrow', 'RightArrow', 'UpArrow', 'DownArrow', 'd', 'a', 's', 'w'};
            if length(obj.fields) > 1
                TEXT{end + 1} = '=,- for adjusting space between the screens,';
                k = [k, {'=+', '-_'}];
            end
            TEXT{end + 1} = 'enter to proceed, escape to exit.';
            k = [k, {'Return', 'ESCAPE'}];
            % Assign keyboard keys to corresponding variables.
            temp = num2cell(KbName(k));

            if length(obj.fields) > 1
                [left, right, up, down, big_hor, small_hor, big_vert, small_vert, big_space, small_space, done, stop] = temp{:};
            else
                [left, right, up, down, big_hor, small_hor, big_vert, small_vert, done, stop] = temp{:};
                big_space = '';
                small_space = '';
            end

            % Create KbQueue for recording provided keys.
            keys = [KbName(k)]; % All keys on right hand plus trigger, can be found by running KbDemo
            keylist = zeros(1, 256); % Create a list of 256 zeros
            keylist(keys) = 1; % Set keys you interested in to 1
            KbQueueCreate(-1, keylist); % Create the queue with the provided keys

            if isempty(frame.color_codes)
                frame.color_codes = {obj.background_color'};
            end
            % Temporarily change frames colors to the provided one.
            frame_color_codes = frame.color_codes;
            frame.color_codes = cellfun(@(hex) (sscanf(hex(2:end), '%2x%2x%2x', [1 3]) / 255)', ...
                                        FRAME_COLOR, ...
                                        UniformOutput = false);

            % Initiate frames with the solid color and provided screen rectangles.
            obj.initiate_fields(frame);
            % Draw frames and flip the screen.
            Screen('FillRect', obj.window, frame.colors, frame.rects);
            obj.draw_text(TEXT);
            Screen('Flip', obj.window);

            % Start queuing keys.
            KbQueueStart;

            key = 0;
            % Run loop until 'done' or 'stop' keys are pressed.
            while 1

                [~, firstPress, firstRelease] = KbQueueCheck();
                % Check if any key was pressed.

                if find(firstPress)
                    key = find(firstPress);
                elseif find(firstRelease)
                    key = 0;
                end

                if ~isscalar(key)
                    continue
                end
                % Change screen rectangles according to the pressed key.
                try
                    switch key
                        case left
                            if (obj.fields{1}.rect(1) - obj.shift) < 0
                                throw(MEBoundary);
                            end
                            obj.correct_fields([1, 3], [true, true]);
                        case right
                            if (obj.fields{2}.rect(3) + obj.shift) > obj.size(1)
                                throw(MEBoundary);
                            end
                            obj.correct_fields([1, 3], [false, false]);
                        case up
                            if (obj.fields{1}.rect(2) - obj.shift) < 0
                                throw(MEBoundary);
                            end
                            obj.correct_fields([2, 4], [true, true]);
                        case down
                            if (obj.fields{1}.rect(4) + obj.shift) > obj.size(2)
                                throw(MEBoundary);
                            end
                            obj.correct_fields([2, 4], [false, false]);
                        case big_hor
                            obj.correct_fields([3], [false, false]);
                        case small_hor
                            if (obj.fields{1}.rect(3) - obj.fields{1}.rect(1) - obj.shift) < 2 * frame.checker_length
                                throw(MESize);
                            end
                            obj.correct_fields([3], [true, true]);
                        case big_vert
                            obj.correct_fields([4], [false, false]);
                        case small_vert
                            if (obj.fields{1}.rect(4) - obj.fields{1}.rect(2) - obj.shift) < 2 * frame.checker_length
                                throw(MESize);
                            end
                            obj.correct_fields([4], [true, true]);
                        case big_space
                            if (obj.fields{1}.rect(1) - obj.shift) < 0 || ...
                                    (obj.fields{2}.rect(3) + obj.shift) > obj.size(1)
                                throw(MEBoundary);
                            end
                            obj.correct_fields([1, 3], [true, false]);
                        case small_space
                            obj.correct_fields([1, 3], [false, true]);
                        case done
                            % Stop the adjustment if the 'done' key was pressed.
                            break
                        case stop
                            % Throw exception if 'stop' key was pressed in order to
                            % stop the experiment execution.
                            throw(MEEsc);
                        case 0
                            % Continue if no key was pressed.
                            continue
                    end

                    % Reinitiate the frames with adjusted screen rectangles.
                    frame.reset();
                    obj.initiate_fields(frame);
                    % Draw frames and flip the screen.
                    Screen('FillRect', obj.window, frame.colors, frame.rects);
                    obj.draw_text(TEXT);
                    Screen('Flip', obj.window);
                    WaitSecs(0.1);

                catch ME
                    switch ME.identifier
                        case "Screen:BoundaryError"
                            Screen('FillRect', obj.window, frame.colors, frame.rects);
                            obj.draw_text({'You have exceeded screen limits.'});
                            Screen('Flip', obj.window);
                        case "Frame:SizeError"
                            Screen('FillRect', obj.window, frame.colors, frame.rects);
                            obj.draw_text({'The frame can not be smaller'});
                            Screen('Flip', obj.window);
                        case "Key:Esc_has_been_pressed"
                            Screen('CloseAll');
                            rethrow(ME);
                        otherwise
                            Screen('FillRect', obj.window, frame.colors, frame.rects);
                            obj.draw_text({'Unexpected error', ME.identifier});
                            Screen('Flip', obj.window);
                    end

                end

            end

            KbQueueStop;

            % Reinitiate the frames with originally provided color codes.
            frame.color_codes = frame_color_codes;
            frame.reset();
            obj.initiate_fields(frame);

        end

    end

    methods (Access = private)

        function correct_fields(obj, coords, is_minus)

            for n = 1:length(obj.fields)
                if is_minus(n)
                    obj.fields{n}.rect(coords) = obj.fields{n}.rect(coords) - obj.shift;
                else
                    obj.fields{n}.rect(coords) = obj.fields{n}.rect(coords) + obj.shift;
                end
            end

        end

        function initiate_fields(obj, frame)

            for n = 1:length(obj.fields)
                frame.initiate(obj.fields{n});
            end

        end

        function draw_text(obj, text)
            text_size = Screen('TextSize', obj.window);
            spacing = round(text_size / 2);
            n_rows = length(text);
            for row = 1:n_rows
                text_bounds = Screen('TextBounds', obj.window, text{row});
                text_length = text_bounds(3) - text_bounds(1);
                for n = 1:length(obj.fields)
                    Screen('DrawText', ...
                           obj.window, ...
                           text{row}, ...
                           round(obj.fields{n}.x_center - text_length / 2), ...
                           round(obj.fields{n}.y_center - (text_size + spacing) * n_rows / 2 + (text_size + spacing) * (row - 1)));
                end
            end

        end

    end

end

function mustBeHex(a)
    if ~regexp(a, "#[\d, A-F]{6}", 'ignorecase')
        error("Provided hex color is wrong.");
    end
end
