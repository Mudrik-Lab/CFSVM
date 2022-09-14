function load_parameters(obj, block)
%load_parameters Loads trial parameters provided in trial matrix.

    matrix = obj.trial_matrices{block};
    for property = matrix(obj.results.trial,:).Properties.VariableNames
        obj.(property{:}) = matrix(obj.results.trial,:).(property{:});
    end
    
    % Calculate useful variables from the parameters provided by the user.
    obj.waitframe = Screen('NominalFrameRate', obj.window)/obj.temporal_frequency;
    obj.delay=1/obj.temporal_frequency - 0.5*obj.inter_frame_interval;
    obj.contrasts = obj.stimulus_contrast/ ...
        (obj.masks_number_while_fade_in*obj.waitframe+1): ...
        obj.stimulus_contrast/(obj.masks_number_while_fade_in*obj.waitframe+1): ...
        obj.stimulus_contrast;
    obj.cumul_masks_number_before_fade_out = ... 
        obj.masks_number_while_stimulus + ...
        obj.masks_number_while_fade_in + ...
        obj.masks_number_before_stimulus;

    obj.mask_indices_while_fade_in = arrayfun(@(n) (floor(obj.masks_number_before_stimulus+(n-1)/obj.waitframe)), ...
        1:(1+obj.masks_number_while_fade_in*obj.waitframe));

    obj.mask_indices_while_fade_out = arrayfun(@(n) (floor(obj.cumul_masks_number_before_fade_out+...
        (obj.masks_number_while_fade_in*obj.waitframe-n)/obj.waitframe)), ...
        1:(obj.masks_number_while_fade_in*obj.waitframe-1));
    
    fixation_cross_lines = [[-obj.fixation_cross_arm_length obj.fixation_cross_arm_length 0 0]; 
        [0 0 -obj.fixation_cross_arm_length obj.fixation_cross_arm_length]];
    obj.fixation_cross_args = ...
        {
            {
                'DrawLines', obj.window, fixation_cross_lines, ...
                obj.fixation_cross_line_width, hex2rgb(obj.fixation_cross_color), ... 
                [obj.left_screen_x_center, obj.left_screen_y_center], 2
            }, ...
            {
                'DrawLines', obj.window, fixation_cross_lines, ...
                obj.fixation_cross_line_width, hex2rgb(obj.fixation_cross_color), ... 
                [obj.right_screen_x_center, obj.right_screen_y_center], 2 
            } 
        };
    
    % Calculate stimulus and masks coordinates on screen.
    obj.stimulus_left_rect = CFS.get_rect(obj.left_side_screen, ...
        obj.checker_rect_width, obj.stimulus_position, obj.stimulus_size, obj.stimulus_xy_ratio);
    obj.stimulus_right_rect =  CFS.get_rect(obj.right_side_screen, obj.checker_rect_width, obj.stimulus_position, obj.stimulus_size, obj.stimulus_xy_ratio);
    if obj.left_suppression==true
        obj.stimulus_rect = obj.stimulus_right_rect;
        obj.masks_rect = obj.stimulus_left_rect;
    else
        obj.stimulus_rect = obj.stimulus_left_rect;
        obj.masks_rect = obj.stimulus_right_rect;
    end
    
    obj.results.stimulus_index = obj.stimulus_index;
end

function rgb = hex2rgb(hex)
    %hex2rgb Transforms hexadecimal color code to MATLAB RGB color code.
    rgb = sscanf(hex(2:end),'%2x%2x%2x',[1 3])/255;
end
