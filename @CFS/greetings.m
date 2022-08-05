function greetings(obj, time_elapsed)
    %greetings(time_elapsed) Summary of this method goes here
    %   Detailed explanation goes here
    INSTRUCTION = sprintf('READY\nIt took %0.1f secs to generate mondrian masks.', time_elapsed);
    Screen('TextFont', obj.window, 'Courier');
    Screen('TextSize', obj.window, 50);
    Screen('TextStyle', obj.window, 1+2);
    DrawFormattedText(obj.window, INSTRUCTION, 'center', 'center')
    Screen('Flip', obj.window);
    
    % Wait for a key to START
    while ~KbWait
    end
end