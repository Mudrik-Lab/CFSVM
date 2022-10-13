function introduction(obj)
%introduction Shows introductory screen.
    text_size = round(obj.screen.left.x_pixels/24);
    KEY = 'space';
    INSTRUCTION = sprintf('Introductory screen. Press %s to continue.', upper(KEY));

    Screen('TextSize', obj.screen.window, text_size)
    Screen('DrawText', obj.screen.window, INSTRUCTION, obj.screen.left.rect(1), round(obj.screen.left.y_center-text_size/2));
    Screen('DrawText', obj.screen.window, INSTRUCTION, obj.screen.right.rect(1), round(obj.screen.right.y_center-text_size/2));

    Screen('Flip', obj.screen.window);
    
    % Wait until the right KEY is pressed, then continue.
    while 1
        [~, keyCode, ~] = KbWait;
        if keyCode(KbName(KEY)) == 1
            break;
        end
    end
    
end

