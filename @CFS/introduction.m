function introduction(obj)
%introduction Shows introduction screen.
%   Detailed explanation goes here
    KEY = 'space';
    INSTRUCTION = sprintf('Start by displaying an instruction screen,\nwith few lines of text.\nIn order to continue, use %s.', upper(KEY));
    Screen('TextFont', obj.window, 'Courier');
    Screen('TextSize', obj.window, 50);
    Screen('TextStyle', obj.window, 1+2);
    DrawFormattedText(obj.window, INSTRUCTION, 'center', 'center')
    Screen('Flip', obj.window);

    % Wait until the right KEY is pressed
    while 1
        [~, keyCode, ~] = KbWait;
        if keyCode(KbName(KEY)) == 1
            break;
        end
    end
    
end

