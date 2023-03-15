function load_args(obj, screen)
% Loads args property with PTB Screen('DrawLines') arguments.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
    
    fixation_cross_lines = [[-obj.arm_length obj.arm_length 0 0]; 
        [0 0 -obj.arm_length obj.arm_length]];
    
    for n = 1:length(screen.fields)
        obj.args{end+1} = ...
        {
            'DrawLines', screen.window, fixation_cross_lines, ...
            obj.line_width, obj.color, ... 
            [screen.fields{n}.x_center, screen.fields{n}.y_center], 2
        };
    end

%     obj.args = ...
%         {
%             {
%                 'DrawLines', screen.window, fixation_cross_lines, ...
%                 obj.line_width, obj.color, ... 
%                 [screen.left.x_center, screen.left.y_center], 2
%             }, ...
%             {
%                 'DrawLines', screen.window, fixation_cross_lines, ...
%                 obj.line_width, obj.color, ... 
%                 [screen.right.x_center, screen.right.y_center], 2 
%             } 
%         };
    
end