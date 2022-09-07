function fixation_cross(obj)
%fixation_cross Draws and shows on the screen the fixation cross.

    % Left screen cross
    Screen(obj.fixation_cross_args{1}{:});
    % Right screen cross
    Screen(obj.fixation_cross_args{2}{:});
    % Flip to the screen
    obj.vbl = Screen('Flip', obj.window);
    obj.results.fixation_onset = obj.vbl;
    
    % Wait for the set fixation duration.
    % Left screen cross
    Screen(obj.fixation_cross_args{1}{:});
    % Right screen cross
    Screen(obj.fixation_cross_args{2}{:});
    obj.vbl = Screen('Flip', obj.window, obj.vbl + obj.fixation_cross_duration - 1/obj.temporal_frequency-0.5*obj.inter_frame_interval);

end


