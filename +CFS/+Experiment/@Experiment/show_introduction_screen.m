function show_introduction_screen(obj)
% Flips screen to the introduction.
%

    PADDING = 10;
    % Calculate text size based on screen X size, 24 is quite arbitrary.
    TEXT_SIZE = round(obj.screen.left.x_pixels/24);
    KEY = 'return';
    INSTRUCTION = sprintf('Hello. Press enter to continue.');

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
    
    if isa(obj, 'CFS.Experiment.CFS')
        % Checkerboard frame
        Screen('FillRect', obj.screen.window, obj.frame.color, obj.frame.rect);
    end
    Screen('Flip', obj.screen.window);
    
    % Wait until the right KEY is pressed, then continue.
    obj.wait_for_keypress(KEY)
    
end

