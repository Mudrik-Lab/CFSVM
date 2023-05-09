function KEY = block_introduction_2(PTB_window, screen_rect)
    KEY = 'return';
    TEXT_SIZE = round((screen_rect(3)-screen_rect(1))/24);
    SPACING = round(TEXT_SIZE/2);
    INSTRUCTION = {'This is an intro to the second block.','Press enter to continue.'};
    N_ROWS = length(INSTRUCTION);
    
    x_center = round(screen_rect(3)-(screen_rect(3)-screen_rect(1))/2);
    y_center = round(screen_rect(4)-(screen_rect(4)-screen_rect(2))/2);
    Screen('TextSize', PTB_window, TEXT_SIZE);
    for row = 1:N_ROWS
        
        text_bounds = Screen('TextBounds', PTB_window, INSTRUCTION{row});
        text_length = text_bounds(3)-text_bounds(1);
        Screen('DrawText', ...
            PTB_window, ...
            INSTRUCTION{row}, ...
            round(x_center-text_length/2), ...
            round(y_center- ...
            (TEXT_SIZE+SPACING)*N_ROWS/2+(TEXT_SIZE+SPACING)*(row-1)));

    end
end
