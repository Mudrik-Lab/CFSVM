function fixation_cross(obj)
%fixation_cross Draws and shows on the screen the fixation cross.
    
    % Set the coordinates (these are all relative to zero we will let
    % the drawing routine center the cross in the center of our monitor for us).
    x_coords = [-obj.fixation_cross_arm_length obj.fixation_cross_arm_length 0 0];
    y_coords = [0 0 -obj.fixation_cross_arm_length obj.fixation_cross_arm_length];
    all_coords = [x_coords; y_coords];
    
    % Draw the fixation cross in white, set it to the center of our screen and
    % set good quality antialiasing.
    Screen('DrawLines', obj.window, all_coords,...
        obj.fixation_cross_line_width, 0, [obj.x_center, obj.y_center], 2);
    
    % Flip to the screen
    obj.vbl = Screen('Flip', obj.window);

    % Stop code execution for the provided amount of time.
    WaitSecs(obj.fixation_cross_duration);
    
end

