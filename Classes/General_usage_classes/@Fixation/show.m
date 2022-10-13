function vbl = show(obj, experiment)
%show Draws and shows fixation cross on the screen.

    % Left screen cross
    Screen(obj.args{1}{:});
    % Right screen cross
    Screen(obj.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', experiment.screen.window, experiment.frame.colors, experiment.frame.rects);
    % Flip to the screen
    obj.onset = Screen('Flip', experiment.screen.window);
    
    % Wait for the set fixation duration.
    % Left screen cross
    Screen(obj.args{1}{:});
    % Right screen cross
    Screen(obj.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', experiment.screen.window, experiment.frame.colors, experiment.frame.rects);
    vbl = Screen('Flip', ...
        experiment.screen.window, ...
        obj.onset + obj.duration - 1/experiment.masks.temporal_frequency-0.5*experiment.screen.inter_frame_interval);

end


