function KEY = introduction(PTB_window, screen_rect)
    KEY = 'return';
    TEXT_SIZE = round((screen_rect(3)-screen_rect(1))/24);
    INTRODUCTION = 'Hello. Press enter to continue.'; 
    
    x_center = round(screen_rect(3)-(screen_rect(3)-screen_rect(1))/2);
    y_center = round(screen_rect(4)-(screen_rect(4)-screen_rect(2))/2);

    Screen('TextSize', PTB_window, TEXT_SIZE);
    text_bounds = Screen('TextBounds', PTB_window, INTRODUCTION);
    text_length = text_bounds(3)-text_bounds(1);
    Screen('DrawText', ...
        PTB_window, ...
        INTRODUCTION, ...
        round(x_center-text_length/2), ...
        y_center-TEXT_SIZE/2);
end

