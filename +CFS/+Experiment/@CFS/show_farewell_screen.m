function show_farewell_screen(obj)
% SHOW_INTRODUCTION_SCREEN Shows introductory screen.

    TEXT_SIZE = round(obj.screen.left.x_pixels/24);
    SPACING = round(TEXT_SIZE/2);
    INSTRUCTION = {'Thank you!', 'The experiment is finished'};
    N_ROWS = length(INSTRUCTION);
    Screen('TextSize', obj.screen.window, TEXT_SIZE);

    for row = 1:N_ROWS

        text_bounds = Screen('TextBounds', obj.screen.window, INSTRUCTION{row});
        text_length = text_bounds(3)-text_bounds(1);

        Screen('DrawText', ...
            obj.screen.window, ...
            INSTRUCTION{row}, ...
            round(obj.screen.left.x_center-text_length/2), ...
            obj.screen.left.y_center-(TEXT_SIZE+SPACING)*N_ROWS/2+(TEXT_SIZE+SPACING)*(row-1));

        Screen('DrawText', ...
            obj.screen.window, ...
            INSTRUCTION{row}, ...
            round(obj.screen.right.x_center-text_length/2), ...
            obj.screen.right.y_center-(TEXT_SIZE+SPACING)*(N_ROWS/2-row+1));

    end

    % Checkerboard frame
    Screen('FillRect', obj.screen.window, obj.frame.color, obj.frame.rect);
    Screen('Flip', obj.screen.window);
    
    % Wait until any key is pressed
    KbStrokeWait
    
end

