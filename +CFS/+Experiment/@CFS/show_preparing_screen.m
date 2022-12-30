function show_preparing_screen(obj)
% SHOW_PREPARING_SCREEN Just informs that the experiment is being prepared.
    
    PADDING = 10;
    % Calculate text size based on screen X size, 24 is quite arbitrary.
    TEXT_SIZE = round(obj.screen.left.x_pixels/24);
    % Text to show.
    INSTRUCTION = sprintf('Preparing the experiment, please wait');

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
    
end

