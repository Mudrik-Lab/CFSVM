function load_fixation_parameters(obj)
%LOAD_FIXATION_PARAMETERS Summary of this function goes here
%   Detailed explanation goes here

    fixation_cross_lines = [[-obj.fixation_cross_arm_length obj.fixation_cross_arm_length 0 0]; 
        [0 0 -obj.fixation_cross_arm_length obj.fixation_cross_arm_length]];
    obj.fixation_cross_args = ...
        {
            {
                'DrawLines', obj.window, fixation_cross_lines, ...
                obj.fixation_cross_line_width, CFS.hex2rgb(obj.fixation_cross_color), ... 
                [obj.screen.left.x_center, obj.screen.left.y_center], 2
            }, ...
            {
                'DrawLines', obj.window, fixation_cross_lines, ...
                obj.fixation_cross_line_width, CFS.hex2rgb(obj.fixation_cross_color), ... 
                [obj.screen.right.x_center, obj.screen.right.y_center], 2 
            } 
        };
end
