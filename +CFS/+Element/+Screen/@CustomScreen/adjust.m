function adjust(obj, frame)
% Creates interface for adjusting screens to the stereoscope view.
%
% Creates two solid frames, that can be moved, resized or shifted relative
% to each other by keyboard keys.
%
% Args:
%   frame: :class:`~+CFS.+Element.+Screen.@CheckFrame` object.
%

    % Number of pixels to change on a keypress.
    SHIFT = obj.shift;
    % Color to use when adjusting the frames.
    FRAME_COLOR = {'#4A4A4A'};
    TEXT = ['Arrows for changing position of both screens,\n', ...
        'w,a,s,d for adjusting height and width,\n', ...
        '=,- for adjusting space between the screens,\n', ...
        'enter to proceed, escape to exit.'];
    
    % Array of used keyboard keys
    k = {'LeftArrow', 'RightArrow', 'UpArrow', 'DownArrow', 'd', 'a', 's', 'w', '=+', '-_' 'Return', 'ESCAPE'};

    % Assign keyboard keys to corresponding variables.
    temp = num2cell(KbName(k));
    [left, right, up, down, big_hor, small_hor, big_vert, small_vert, big_space, small_space, done, stop] = temp{:};
    
    % Create KbQueue for recording provided keys.
    keys=[KbName(k)]; % All keys on right hand plus trigger, can be found by running KbDemo
    keylist=zeros(1,256); % Create a list of 256 zeros
    keylist(keys)=1; % Set keys you interested in to 1
    KbQueueCreate(-1,keylist); % Create the queue with the provided keys
    
    % Temporarily change frames colors to the provided one.
    frame_color_codes = frame.color_codes;
    frame.color_codes = cellfun(@(hex) (sscanf(hex(2:end), '%2x%2x%2x', [1 3])/255)', ...
                FRAME_COLOR, ...
                UniformOutput=false);
    
    % Initiate frames with the solid color and provided screen rectangles.
    frame.initiate(obj);

    % Draw frames and flip the screen.
    Screen('FillRect', obj.window, frame.color, frame.rect);

    DrawFormattedText(obj.window, TEXT, obj.left.rect(1)+frame.checker_width, obj.left.rect(2)+frame.checker_width*2);
    DrawFormattedText(obj.window, TEXT, obj.right.rect(1)+frame.checker_width, obj.right.rect(2)+frame.checker_width*2);

    Screen('Flip', obj.window);

    % Start queuing keys.
    KbQueueStart;

    % Run loop until 'done' or 'stop' keys are pressed. 
    while 1

        [~, firstPress] = KbQueueCheck();
        
        % Check if something was pressed.
        if find(firstPress)
            key = find(firstPress);
        else
            key = 0;
        end
        
        % Change screen rectangles according to the pressed key.
        try
            switch key   
                case left
                    obj.left.rect([1,3]) = obj.left.rect([1,3]) - SHIFT;
                    obj.right.rect([1,3]) = obj.right.rect([1,3]) - SHIFT;
                case right
                    obj.left.rect([1,3]) = obj.left.rect([1,3]) + SHIFT;
                    obj.right.rect([1,3]) = obj.right.rect([1,3]) + SHIFT;
                case up
                    obj.left.rect([2,4]) = obj.left.rect([2,4]) - SHIFT;
                    obj.right.rect([2,4]) = obj.right.rect([2,4]) - SHIFT;
                case down
                    obj.left.rect([2,4]) = obj.left.rect([2,4]) + SHIFT;
                    obj.right.rect([2,4]) = obj.right.rect([2,4]) + SHIFT;
                case big_hor
                    obj.left.rect(3) = obj.left.rect(3) + SHIFT;
                    obj.right.rect(3) = obj.right.rect(3) + SHIFT;
                case small_hor
                    obj.left.rect(3) = obj.left.rect(3) - SHIFT;
                    obj.right.rect(3) = obj.right.rect(3) - SHIFT;
                case big_vert
                    obj.left.rect(4) = obj.left.rect(4) + SHIFT;
                    obj.right.rect(4) = obj.right.rect(4) + SHIFT;
                case small_vert
                    obj.left.rect(4) = obj.left.rect(4) - SHIFT;
                    obj.right.rect(4) = obj.right.rect(4) - SHIFT;
                case big_space
                    obj.left.rect([1,3]) = obj.left.rect([1,3]) - SHIFT;
                    obj.right.rect([1,3]) = obj.right.rect([1,3]) + SHIFT;
                case small_space
                    obj.left.rect([1,3]) = obj.left.rect([1,3]) + SHIFT;
                    obj.right.rect([1,3]) = obj.right.rect([1,3]) - SHIFT;
                case done
                    % Stop the adjustment if the 'done' key was pressed.
                    break;
                case stop
                    % Throw exception if 'stop' key was pressed in order to 
                    % stop the experiment execution.
                    ME = MException('Key:Esc_has_been_pressed', ...
                        'Esc has been pressed, the program has been terminated.');
                    throw(ME)
                case 0
                    % Continue if no key was pressed.
                    continue;
            end
        
            % Reinitiate the frames with adjusted screen rectangles.
            frame.initiate(obj);
            Screen('FillRect', obj.window, frame.color, frame.rect);
            DrawFormattedText(obj.window, TEXT, obj.left.rect(1)+frame.checker_width, obj.left.rect(2)+frame.checker_width*2);
            DrawFormattedText(obj.window, TEXT, obj.right.rect(1)+frame.checker_width, obj.right.rect(2)+frame.checker_width*2);
            Screen('Flip', obj.window);
        
        catch ME
        
            if ME.identifier == "Key:Esc_has_been_pressed"
                Screen('CloseAll');
                rethrow(ME);
            else
                % If can't reduce screen no more - show warning.
                % If there is another exception it will be catched here as
                % well.
                Screen('FillRect', obj.window, frame.color, frame.rect);
                DrawFormattedText(obj.window, ...
                    ['You have probably reached the limit, ' ...
                    'but maybe not, you can try further or return it as it was.' ...
                    '\nDo not press enter with this warning on screen.'], 'center', 'center');
                Screen('Flip', obj.window);
            end
        
        end
        
    end

    KbQueueStop;

    % Reinitiate the frames with originally provided color codes.
    frame.color_codes = frame_color_codes;
    frame.initiate(obj);


end

