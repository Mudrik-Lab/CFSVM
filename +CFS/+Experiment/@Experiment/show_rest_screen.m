function show_rest_screen(obj)
% Flips screen to the rest message.
%

    TEXT_SIZE = round(obj.screen.fields{1}.x_pixels/24);
    SPACING = round(TEXT_SIZE/2);
    INSTRUCTION = {'Press enter to continue.'};
    N_ROWS = length(INSTRUCTION);
    Screen('TextSize', obj.screen.window, TEXT_SIZE);

    for row = 1:N_ROWS

        text_bounds = Screen('TextBounds', obj.screen.window, INSTRUCTION{row});
        text_length = text_bounds(3)-text_bounds(1);
        
        for n = 1:length(obj.screen.fields)
            Screen('DrawText', ...
                obj.screen.window, ...
                INSTRUCTION{row}, ...
                round(obj.screen.fields{n}.x_center-text_length/2), ...
                round(obj.screen.fields{n}.y_center-(TEXT_SIZE+SPACING)*N_ROWS/2+(TEXT_SIZE+SPACING)*(row-1)));
        end
%         Screen('DrawText', ...
%             obj.screen.window, ...
%             INSTRUCTION{row}, ...
%             round(obj.screen.right.x_center-text_length/2), ...
%             round(obj.screen.right.y_center-(TEXT_SIZE+SPACING)*(N_ROWS/2-row+1)));

    end


    if isa(obj, "CFS.Experiment.CFS")
        % Checkerboard frame
        Screen('FillRect', obj.screen.window, obj.frame.color, obj.frame.rect);
    end

    Screen('Flip', obj.screen.window);

    
end