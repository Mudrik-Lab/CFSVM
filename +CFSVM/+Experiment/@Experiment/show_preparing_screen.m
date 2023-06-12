function show_preparing_screen(obj)
    % Flips screen to inform that the experiment is being prepared.
    %

    PADDING = 10;
    % Calculate text size based on screen X size, 24 is quite arbitrary.
    TEXT_SIZE = round(obj.screen.fields{1}.x_pixels / 24);
    % Text to show.
    INSTRUCTION = sprintf('Preparing the experiment, please wait');

    Screen('TextSize', obj.screen.window, TEXT_SIZE);
    for n = 1:length(obj.screen.fields)
        Screen('DrawText', ...
               obj.screen.window, ...
               INSTRUCTION, ...
               obj.screen.fields{n}.rect(1) + PADDING, ...
               round(obj.screen.fields{n}.y_center - TEXT_SIZE / 2));
    end

    if isa(obj, "CFSVM.Experiment.CFS")
        % Checkerboard frame
        Screen('FillRect', obj.screen.window, obj.frame.colors, obj.frame.rects);
    end

    Screen('Flip', obj.screen.window);

end
