function show_rest_screen(obj)
% SHOW_REST_SCREEN Shows rest_screen.
    text_size = round(obj.screen.left.x_pixels/24);
    KEY = 'return';
    INSTRUCTION = sprintf('Take a slow deep breath. Press %s to continue.', upper(KEY));
    
    Screen('TextSize', obj.screen.window, text_size)
    Screen('DrawText', obj.screen.window, INSTRUCTION, obj.screen.left.rect(1), round(obj.screen.left.y_center-text_size/2));
    Screen('DrawText', obj.screen.window, INSTRUCTION, obj.screen.right.rect(1), round(obj.screen.right.y_center-text_size/2));
    % Checkerboard frame
    Screen('FillRect', obj.screen.window, obj.frame.color, obj.frame.rect);
    Screen('Flip', obj.screen.window);
    
    % Wait until the right KEY is pressed, then continue.
    while 1
        [~, keyCode, ~] = KbWait;
        if keyCode(KbName(KEY)) == 1
            break;
        end
    end
    
end