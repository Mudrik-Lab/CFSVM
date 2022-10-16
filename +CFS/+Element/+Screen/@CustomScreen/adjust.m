function adjust(obj, frame)
%ADJUST Summary of this function goes here
%   Detailed explanation goes here
    SHIFT = obj.shift;
    k = {'LeftArrow', 'RightArrow', 'UpArrow', 'DownArrow', 'd', 'a', 's', 'w', '=+', '-_' 'Return', 'ESCAPE'};
    temp = num2cell(KbName(k));
    [left, right, up, down, big_hor, small_hor, big_vert, small_vert, big_space, small_space, done, stop] = temp{:};
    
    keys=[KbName(k)]; % All keys on right hand plus trigger, can be found by running KbDemo
    keylist=zeros(1,256); % Create a list of 256 zeros
    keylist(keys)=1; % Set keys you interested in to 1
    KbQueueCreate(-1,keylist); % Create the queue with the provided keys

    
    Screen('FillRect', obj.window, frame.color, frame.rect);
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
                    obj.left.rect([3]) = obj.left.rect([3]) + SHIFT;
                    obj.right.rect([3]) = obj.right.rect([3]) + SHIFT;
                case small_hor
                    obj.left.rect([3]) = obj.left.rect([3]) - SHIFT;
                    obj.right.rect([3]) = obj.right.rect([3]) - SHIFT;
                case big_vert
                    obj.left.rect([4]) = obj.left.rect([4]) + SHIFT;
                    obj.right.rect([4]) = obj.right.rect([4]) + SHIFT;
                case small_vert
                    obj.left.rect([4]) = obj.left.rect([4]) - SHIFT;
                    obj.right.rect([4]) = obj.right.rect([4]) - SHIFT;
                case big_space
                    obj.left.rect([3]) = obj.left.rect([3]) - SHIFT;
                    obj.right.rect([1]) = obj.right.rect([1]) + SHIFT;
                case small_space
                    obj.left.rect([3]) = obj.left.rect([3]) + SHIFT;
                    obj.right.rect([1]) = obj.right.rect([1]) - SHIFT;
                case done
                    break;
                case stop
                    ME = MException('Key:Esc_has_been_pressed', ...
                        'Esc has been pressed, the program has been terminated.');
                    throw(ME)
                case 0
                    continue;
            end
            frame.initiate(obj.left.rect, obj.right.rect);
            Screen('FillRect', obj.window, frame.color, frame.rect);
            Screen('Flip', obj.window);
        
        catch ME
            if ME.identifier == "Key:Esc_has_been_pressed"
                Screen('CloseAll');
                rethrow(ME);
            else
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
end

