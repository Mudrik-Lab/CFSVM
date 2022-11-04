function load_args(obj, screen)
% LOAD_ARGS Loads args property with PTB Screen('DrawLines') arguments.
    
    fixation_cross_lines = [[-obj.arm_length obj.arm_length 0 0]; 
        [0 0 -obj.arm_length obj.arm_length]];
    
    obj.args = ...
        {
            {
                'DrawLines', screen.window, fixation_cross_lines, ...
                obj.line_width, obj.color, ... 
                [screen.left.x_center, screen.left.y_center], 2
            }, ...
            {
                'DrawLines', screen.window, fixation_cross_lines, ...
                obj.line_width, obj.color, ... 
                [screen.right.x_center, screen.right.y_center], 2 
            } 
        };
    
end