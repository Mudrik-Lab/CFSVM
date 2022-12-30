function show_introduction_screen(obj)
% SHOW_INTRODUCTION_SCREEN Shows introductory screen.
    PADDING = 10;
    % Calculate text size based on screen X size, 24 is quite arbitrary.
    TEXT_SIZE = round(obj.screen.left.x_pixels/24);
    KEY = 'space';
    INSTRUCTION = sprintf('Introductory screen. Press %s to continue.', upper(KEY));

    Screen('TextSize', obj.screen.window, TEXT_SIZE);
    Screen('DrawText', ...
        obj.screen.window, ...
        INSTRUCTION, ...
        obj.screen.left.rect(1)+PADDING, ...
        round(obj.screen.left.y_center-TEXT_SIZE/2));
    Screen('DrawText', ...
        obj.screen.window, ...
        INSTRUCTION, ...
        obj.screen.right.rect(1)+PADDING, ...
        round(obj.screen.right.y_center-TEXT_SIZE/2));
    
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

