function introduction(obj)
%introduction Shows introductory screen.

    KEY = 'space';
    INSTRUCTION = sprintf('Here will be the introductory screen.\n Press %s to continue.', upper(KEY));
    DrawFormattedText(obj.window, INSTRUCTION, 'center', 'center');
    Screen('Flip', obj.window);
    
    % Wait until the right KEY is pressed, then continue.
    while 1
        [~, keyCode, ~] = KbWait;
        if keyCode(KbName(KEY)) == 1
            break;
        end
    end
    
end

