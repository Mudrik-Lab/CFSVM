function flash(obj, vbl)
% FLASH Flashes stimuli, masks, fixations and checkframe.
% The main method for flashing CFS and recording its timings.
    
    % First flashing frame is being delayed to present an initial fixation 
    % for the exact duration.
    draw(obj, 1)
    obj.vbl_recs(1) = Screen(...
        'Flip', ...
        obj.screen.window, ...
        vbl + obj.fixation.duration - 0.5*obj.screen.inter_frame_interval);

    % Flash frames for provided masks duration.
    for fr = 2:(obj.masks.duration*obj.screen.frame_rate)
        draw(obj, fr)
        obj.vbl_recs(fr) = Screen('Flip', obj.screen.window);
    end
    
    % Present the last frame for a longer time to enable smooth transition
    % to the next experiment stage (e.g., rest screen).
    draw(obj, fr)
    obj.vbl_recs(end+1) = Screen('Flip', obj.screen.window);
end


function draw(obj, fr)
    % Stimuli and Mondrians
    Screen(obj.masks.args{fr}{:});
    % Left screen cross
    Screen(obj.fixation.args{1}{:});
    % Right screen cross
    Screen(obj.fixation.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', obj.screen.window, obj.frame.color, obj.frame.rect);
end