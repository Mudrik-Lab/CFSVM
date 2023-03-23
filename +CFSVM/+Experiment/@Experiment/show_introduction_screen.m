function show_introduction_screen(obj)
% Flips screen to the introduction.
%

    PADDING = 10;
    % Calculate text size based on screen X size, 24 is quite arbitrary.
    TEXT_SIZE = round(obj.screen.fields{1}.x_pixels/24);
    KEY = 'return';
    INSTRUCTION = sprintf('Hello. Press enter to continue.');

    Screen('TextSize', obj.screen.window, TEXT_SIZE);

    for n = 1:length(obj.screen.fields)
        Screen('DrawText', ...
            obj.screen.window, ...
            INSTRUCTION, ...
            obj.screen.fields{n}.rect(1)+PADDING, ...
            round(obj.screen.fields{n}.y_center-TEXT_SIZE/2));
    end
    
    if isa(obj, "CFSVM.Experiment.CFS")
        % Checkerboard frame
        Screen('FillRect', obj.screen.window, obj.frame.colors, obj.frame.rects);
    end
    Screen('Flip', obj.screen.window);
    
    % Wait until the right KEY is pressed, then continue.
    obj.wait_for_keypress(KEY)
    
end

