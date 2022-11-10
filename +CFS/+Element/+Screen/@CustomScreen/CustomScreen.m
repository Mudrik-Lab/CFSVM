classdef CustomScreen < handle
% CUSTOMSCREEN Screen class for storing parameters of the left and right areas.
    
    properties

        left
        right
        shift
        background_color
        window
        inter_frame_interval
        frame_rate
        
    end


    methods
        
        function obj = CustomScreen(parameters)
            % CUSTOMSCREEN Constructs an instance of this class
            % Gets optional keyword arguments:
            % left_screen_rect
            % right_screen_rect
            arguments
                parameters.background_color
                parameters.initial_left_screen_rect = [0, 0, 945, 1080];
                parameters.initial_right_screen_rect = [975, 0, 1920, 1080];
                parameters.adjust_shift = 15
            end
            
            obj.background_color = parameters.background_color;
            obj.left = CFS.Element.Screen.ScreenField(parameters.initial_left_screen_rect);
            obj.right = CFS.Element.Screen.ScreenField(parameters.initial_right_screen_rect);
            obj.shift = parameters.adjust_shift;
            
        end
        
        adjust(obj, frame)

    end

end

