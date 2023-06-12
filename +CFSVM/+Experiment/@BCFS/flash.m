function [pressed, first_press] = flash(obj, vbl)
% Flashes stimuli, masks, fixations and checkframe.
%
% This is the main method for flashing CFS and recording its timings.
% 
% Args:
%   vbl: An integer for vertical retrace timing from the fixation.show().
% Returns:
%   [pressed, first_press]: bool and array:
%
%   - pressed: a boolean indicating whether a key has been pressed
%   - first_press: an array indicating the time that each key was first pressed.
%

    
    % First flashing frame is being delayed to present an initial fixation
    % for its exact duration.
    draw(obj, 1)
    [obj.flips(1,1), obj.flips(2,1), obj.flips(3,1), ...
        obj.flips(4,1), obj.flips(5,1)] = Screen(...
        'Flip', ...
        obj.screen.window, ...
        vbl + obj.fixation.duration - 0.5*obj.screen.inter_frame_interval);

    [pressed, first_press, ~, ~, ~] = KbQueueCheck();
    if pressed
        return;
    end
    % Flash frames for provided masks duration.
    for fr = 2:(obj.masks.duration*obj.screen.frame_rate)
        draw(obj, fr)
        [obj.flips(1,fr), obj.flips(2,fr), obj.flips(3,fr), ...
            obj.flips(4,fr), obj.flips(5,fr)] = Screen(...
            'Flip', ...
            obj.screen.window, ...
            obj.flips(1,fr-1)-0.5*obj.screen.inter_frame_interval);
        [pressed, first_press, ~, ~, ~] = KbQueueCheck();
        if pressed
            return;
        end
    end
    
    
    if obj.masks.blank > 0
        
        % Show blank screen for the duration provided in 'blank'.
        draw_fixation_and_frame(obj)
        [obj.flips(1,end+1), obj.flips(2,end+1), obj.flips(3,end+1), ...
            obj.flips(4,end+1), obj.flips(5,end+1)] = Screen(...
            'Flip', ...
            obj.screen.window, ...
            obj.flips(1,end)-0.5*obj.screen.inter_frame_interval);

        draw_fixation_and_frame(obj)
        Screen('Flip', ...
            obj.screen.window, ...
            obj.flips(1,end)+obj.masks.blank-0.5*obj.screen.inter_frame_interval);
            
    else

        % Present the last frame for a longer time to enable smooth transition
        % to the next experiment stage (e.g., rest screen).
        draw(obj, fr)
        [obj.flips(1,end+1), obj.flips(2,end+1), obj.flips(3,end+1), ...
            obj.flips(4,end+1), obj.flips(5,end+1)] = Screen(...
            'Flip', ...
            obj.screen.window, ...
            obj.flips(1,end)-0.5*obj.screen.inter_frame_interval);

    end

end


function draw(obj, fr)
    % Stimuli and Mondrians
    Screen(obj.masks.args{fr}{:});
    draw_fixation_and_frame(obj)
end

function draw_fixation_and_frame(obj)
    % Left screen cross
    Screen(obj.fixation.args{1}{:});
    % Right screen cross
    Screen(obj.fixation.args{2}{:});
    % Checkerboard frame
    Screen('FillRect', obj.screen.window, obj.frame.colors, obj.frame.rects);
end