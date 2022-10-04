function adjust_screens(obj)
%ADJUST_SCREENS Summary of this function goes here
%   Detailed explanation goes here
    k = {'LeftArrow', 'RightArrow', 'UpArrow', 'DownArrow', 'd', 'a', 's', 'w', '=+', '-_' 'Return', 'ESCAPE'};
    temp = num2cell(KbName(k));
    [left, right, up, down, big_hor, small_hor, big_vert, small_vert, big_space, small_space, done, stop] = temp{:};
    
    keys=[KbName(k)]; % All keys on right hand plus trigger, can be found by running KbDemo
    keylist=zeros(1,256); % Create a list of 256 zeros
    keylist(keys)=1; % Set keys you interested in to 1
    KbQueueCreate(-1,keylist); % Create the queue with the provided keys

    shift = 10;
    Screen('FillRect', obj.window, obj.checker_colors, obj.checker_rects);
    Screen('Flip', obj.window);
    KbQueueStart;
    while 1

        [~, firstPress] = KbQueueCheck();

        if find(firstPress)
            key = find(firstPress);
        else
            key = 0;
        end
        
        try
            switch key   
                case left
                    obj.left_side_screen([1,3]) = obj.left_side_screen([1,3]) - shift;
                    obj.right_side_screen([1,3]) = obj.right_side_screen([1,3]) - shift;
                case right
                    obj.left_side_screen([1,3]) = obj.left_side_screen([1,3]) + shift;
                    obj.right_side_screen([1,3]) = obj.right_side_screen([1,3]) + shift;
                case up
                    obj.left_side_screen([2,4]) = obj.left_side_screen([2,4]) - shift;
                    obj.right_side_screen([2,4]) = obj.right_side_screen([2,4]) - shift;
                case down
                    obj.left_side_screen([2,4]) = obj.left_side_screen([2,4]) + shift;
                    obj.right_side_screen([2,4]) = obj.right_side_screen([2,4]) + shift;
                case big_hor
                    obj.left_side_screen([3]) = obj.left_side_screen([3]) + shift;
                    obj.right_side_screen([3]) = obj.right_side_screen([3]) + shift;
                case small_hor
                    obj.left_side_screen([3]) = obj.left_side_screen([3]) - shift;
                    obj.right_side_screen([3]) = obj.right_side_screen([3]) - shift;
                case big_vert
                    obj.left_side_screen([4]) = obj.left_side_screen([4]) + shift;
                    obj.right_side_screen([4]) = obj.right_side_screen([4]) + shift;
                case small_vert
                    obj.left_side_screen([4]) = obj.left_side_screen([4]) - shift;
                    obj.right_side_screen([4]) = obj.right_side_screen([4]) - shift;
                case big_space
                    obj.left_side_screen([3]) = obj.left_side_screen([3]) - shift;
                    obj.right_side_screen([1]) = obj.right_side_screen([1]) + shift;
                case small_space
                    obj.left_side_screen([3]) = obj.left_side_screen([3]) + shift;
                    obj.right_side_screen([1]) = obj.right_side_screen([1]) - shift;
                case done
                    break;
                case stop
                    ME = MException('Key:Esc_has_been_pressed', ...
                        'Esc has been pressed, the program has been terminated.');
                    throw(ME)
                case 0
                    continue;
            end
            obj.initiate_checkerboard_frame();
            Screen('FillRect', obj.window, obj.checker_colors, obj.checker_rects);
            Screen('Flip', obj.window);
        catch ME
            if ME.identifier == "Key:Esc_has_been_pressed"
                Screen('CloseAll');
                rethrow(ME);
            else
                Screen('FillRect', obj.window, obj.checker_colors, obj.checker_rects);
                DrawFormattedText(obj.window, ...
                    ['You have probably reached the limit, ' ...
                    'but maybe not, you can try further or return it as it was.' ...
                    '\nDo not press enter with this warning on screen.'], 'center', 'center')
                Screen('Flip', obj.window);
            end      
         end
        
    end
    KbQueueStop;
end

